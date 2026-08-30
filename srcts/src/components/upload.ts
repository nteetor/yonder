import type { ShinyApp } from 'rstudio-shiny/srcts/types/src/shiny/shinyapp';
import type { UploadInitValue } from 'rstudio-shiny/srcts/types/src/file/fileProcessor';

// One run of Shiny's upload protocol for a batch of files, jQuery-free
// and free of any DOM assumptions. One upload job per file, so POSTs can
// overlap:
//
//   1. `uploadInit([{name, size, type}])` once per file, all of them
//      issued and answered before any bytes move; the server validates
//      each size against `shiny.maxRequestSize` and answers
//      {jobId, uploadUrl}.
//   2. One HTTP POST per file to its own job's url, carrying the raw
//      bytes as application/octet-stream, at most UPLOAD_CONCURRENCY in
//      flight at a time.
//   3. `uploadEnd(jobId, slotId)` per file as its POST lands, where
//      slotId names a per-position companion input. The server sets that
//      slot to the file's one-row data frame; the caller then sends the
//      batch payload — a file count — that R's `bsides.file.batch`
//      handler assembles into input$<id>, once, in declared order.
//
// One job per file is forced by the server side: FileUploadOperation
// binds declared metadata to POSTs by arrival order and keeps a single
// file handle open, so concurrent POSTs into one job would scramble
// name/content attribution.
//
// XHR, not fetch: upload progress events on fetch still require duplex
// request streams (Chromium-only); xhr.upload.onprogress is the portable
// mechanism, and xhr.abort() gives cancellation for free.

// Dropzone defaults to 2, Uppy to 5. Small-file batches are latency-
// bound, so the exact value matters less than it not being 1.
const UPLOAD_CONCURRENCY = 4;

// A progress checkpoint. Files upload concurrently, so checkpoints from
// different files interleave: `loaded` is this file's own bytes, and
// `batch` the aggregate across every file, which never decreases.
interface UploadProgress {
  // The file being sent, or null at batch checkpoints (start, finish).
  file: File | null;
  // Bytes of `file` sent so far.
  loaded: number;
  // Fraction of the whole batch sent so far, in [0, 1].
  batch: number;
}

interface UploaderCallbacks {
  onProgress?: (progress: UploadProgress) => void;
  onFileDone?: (file: File) => void;
  // `file` is the one whose transfer failed, when the failure belongs to
  // a single file rather than the batch — its siblings were aborted, not
  // at fault, so only this one has earned a mark.
  onError?: (message: string, file?: File) => void;
  onDone?: () => void;
}

interface UploaderOptions extends UploaderCallbacks {
  inputId: string;
  files: File[];
}

// The companion input a file's job is finished into. Indexed by declared
// position, 1-based: batches never overlap for one input, so positions
// are safe to reuse. `file_batch_slot_id()` in R/input-file.R rebuilds
// these same names from the batch's file count — keep the two in step.
function slotId(inputId: string, index: number): string {
  return `${inputId}__bsides_slot_${index + 1}`;
}

// Names the file a rejection belongs to, so a batch dying with several
// transfers in flight can still say which one failed.
class FileError extends Error {
  file: File;

  constructor(file: File, cause: unknown) {
    super(messageOf(cause));

    this.file = file;
  }
}

function fileOf(error: unknown): File | undefined {
  return error instanceof FileError ? error.file : undefined;
}

class Uploader {
  #inputId: string;
  #files: File[];
  #callbacks: UploaderCallbacks;
  #totalBytes: number;
  #loaded: number[];
  #shinyapp: ShinyApp | null = null;
  #inflight = new Set<XMLHttpRequest>();
  #aborted = false;
  #finished = false;

  constructor(options: UploaderOptions) {
    const { inputId, files, ...callbacks } = options;

    this.#inputId = inputId;
    this.#files = files;
    this.#callbacks = callbacks;
    this.#totalBytes = files.reduce((total, file) => total + file.size, 0);
    this.#loaded = files.map(() => 0);
  }

  // The batch payload carries this, not the slot names: the server
  // derives `<id>__bsides_slot_<i>` itself rather than dereferencing
  // strings off the wire.
  get count(): number {
    return this.#files.length;
  }

  // Runs the whole batch. Resolves once the batch has ended for any
  // reason — completion, error, or cancellation; callers observe which
  // through the callbacks.
  async run(): Promise<void> {
    const shinyapp = window.Shiny?.shinyapp;

    if (!shinyapp?.isConnected()) {
      this.#fail('Not connected to the server.');
      return;
    }

    this.#shinyapp = shinyapp;

    if (this.#files.length === 0) {
      this.#finish();
      return;
    }

    this.#progress(null, 0, 0);

    let jobs: UploadInitValue[];

    // Every init before any POST: `shiny.maxRequestSize` is enforced here,
    // so an oversize file anywhere fails the batch with nothing sent.
    try {
      jobs = await Promise.all(
        this.#files.map((file) => this.#uploadInit(file)),
      );
    } catch (error) {
      this.#fail(messageOf(error), fileOf(error));
      return;
    }

    if (this.#isStopped()) {
      return;
    }

    // Workers report their own failures, so this settles only when every
    // transfer chain has. A stopped batch may leave it pending — a
    // sibling's `uploadEnd` outliving the socket — which is harmless:
    // onError has already fired, and run()'s promise is fired as void.
    await this.#transferAll(jobs);

    if (this.#isStopped()) {
      return;
    }

    this.#progress(null, 0, 1);
    this.#finish();
  }

  // Un-ended jobs are orphaned server-side; the session cleans them and
  // their temp files up.
  cancel(): void {
    if (this.#finished) {
      return;
    }

    this.#finished = true;
    this.#stop();
  }

  async #transferAll(jobs: UploadInitValue[]): Promise<void> {
    let next = 0;

    const worker = async (): Promise<void> => {
      for (;;) {
        const index = next++;

        if (index >= this.#files.length || this.#isStopped()) {
          return;
        }

        try {
          await this.#transfer(jobs[index], this.#files[index], index);
        } catch (error) {
          // Reported here rather than by rejecting the worker: a caller
          // awaiting every worker would hold the failure behind a sibling
          // that never settles — Shiny's client leaves an `uploadEnd`
          // request pending forever on a dropped socket rather than
          // rejecting it. #fail is idempotent, so the sibling rejections
          // that follow the abort are absorbed.
          this.#fail(messageOf(error), fileOf(error));

          return;
        }
      }
    };

    const workers = Math.min(UPLOAD_CONCURRENCY, this.#files.length);

    await Promise.all(Array.from({ length: workers }, () => worker()));
  }

  // No barrier between files: a small file's job closes while a large one
  // is still on the wire.
  async #transfer(
    job: UploadInitValue,
    file: File,
    index: number,
  ): Promise<void> {
    this.#progress(file, this.#loaded[index], this.#fraction());

    try {
      await this.#post(job.uploadUrl, file, index);

      if (this.#isStopped()) {
        return;
      }

      await this.#uploadEnd(job.jobId, slotId(this.#inputId, index));
    } catch (error) {
      throw new FileError(file, error);
    }

    if (this.#isStopped()) {
      return;
    }

    // Settle the file's byte count in case its last progress event never
    // arrived, then report the batch alone: a checkpoint naming the file
    // would put its row back under way after it has been marked done.
    this.#loaded[index] = file.size;
    this.#callbacks.onFileDone?.(file);
    this.#progress(null, 0, this.#fraction());
  }

  #uploadInit(file: File): Promise<UploadInitValue> {
    const info = [{ name: file.name, size: file.size, type: file.type }];

    return this.#request('uploadInit', [info]).catch((error: unknown) => {
      throw new FileError(file, error);
    }) as Promise<UploadInitValue>;
  }

  #uploadEnd(jobId: string, slot: string): Promise<unknown> {
    return this.#request('uploadEnd', [jobId, slot]);
  }

  // Only reachable after run() has stored the connected app.
  #request(method: string, args: unknown[]): Promise<unknown> {
    const shinyapp = this.#shinyapp;

    if (!shinyapp) {
      return Promise.reject(new Error('Not connected to the server.'));
    }

    return new Promise((resolve, reject) => {
      shinyapp.makeRequest(
        method,
        args,
        resolve,
        (error) => reject(new Error(error)),
        undefined,
      );
    });
  }

  #post(url: string, file: File, index: number): Promise<void> {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();

      this.#inflight.add(xhr);

      xhr.open('POST', url, true);
      xhr.setRequestHeader('Content-Type', 'application/octet-stream');

      xhr.upload.onprogress = (event) => {
        if (event.lengthComputable) {
          // Held at its high-water mark: a transfer that restarts its
          // progress sequence reports fewer bytes than it last did, and
          // neither this file's bar nor the batch's may walk backwards.
          this.#loaded[index] = Math.max(this.#loaded[index], event.loaded);
          this.#progress(file, this.#loaded[index], this.#fraction());
        }
      };

      xhr.onload = () => {
        this.#inflight.delete(xhr);

        if (xhr.status >= 200 && xhr.status < 300) {
          resolve();
        } else {
          reject(
            new Error(xhr.responseText || `Upload failed (${xhr.status})`),
          );
        }
      };

      xhr.onerror = () => {
        this.#inflight.delete(xhr);
        reject(new Error('Upload failed.'));
      };

      // cancel() aborts the request. Resolving unwinds the chain, whose
      // post-await cancellation check stops it without an error.
      xhr.onabort = () => {
        this.#inflight.delete(xhr);
        resolve();
      };

      xhr.send(file);
    });
  }

  // No `uploadEnd` runs for a stopped file, so its slot stays empty, and
  // without a full set the caller sends no batch payload — which is what
  // keeps a dead batch from delivering a partial value.
  #stop(): void {
    this.#aborted = true;

    const requests = [...this.#inflight];

    this.#inflight.clear();

    for (const xhr of requests) {
      xhr.abort();
    }
  }

  // Read through a call, not the field: a cancel or a sibling's failure
  // lands between the awaits in the transfer chains, which control-flow
  // narrowing of a plain field read cannot account for.
  #isStopped(): boolean {
    return this.#aborted;
  }

  // The batch fraction. Monotone by construction rather than by clamping
  // here: every counter it sums is held at its own high-water mark, and a
  // sum of counters that never fall cannot fall either.
  #fraction(): number {
    if (this.#totalBytes <= 0) {
      return 0;
    }

    const sent = this.#loaded.reduce((total, bytes) => total + bytes, 0);

    return sent / this.#totalBytes;
  }

  #progress(file: File | null, loaded: number, batch: number): void {
    // A batch that has stopped reports nothing further: an aborted POST
    // can still deliver a queued progress event, and the caller must not
    // see the dead batch move.
    if (this.#isStopped()) {
      return;
    }

    this.#callbacks.onProgress?.({
      file,
      loaded,
      batch: Math.min(Math.max(batch, 0), 1),
    });
  }

  #fail(message: string, file?: File): void {
    if (this.#finished) {
      return;
    }

    this.#finished = true;
    this.#stop();
    this.#callbacks.onError?.(message, file);
  }

  #finish(): void {
    if (this.#finished) {
      return;
    }

    this.#finished = true;
    this.#callbacks.onDone?.();
  }
}

function messageOf(error: unknown): string {
  if (error instanceof Error) {
    return error.message || 'Upload failed.';
  }

  return typeof error === 'string' && error ? error : 'Upload failed.';
}

export { Uploader, UPLOAD_CONCURRENCY };
export type { UploadProgress, UploaderCallbacks, UploaderOptions };
