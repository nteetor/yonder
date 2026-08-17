import type { ShinyApp } from 'rstudio-shiny/srcts/types/src/shiny/shinyapp';
import type { UploadInitValue } from 'rstudio-shiny/srcts/types/src/file/fileProcessor';

// One run of Shiny's three-leg upload protocol, jQuery-free and free of
// any DOM assumptions:
//
//   1. `uploadInit` over the WebSocket announces [{name, size, type}, ...];
//      the server validates sizes against `shiny.maxRequestSize` and
//      answers {jobId, uploadUrl}.
//   2. One HTTP POST per file, sequentially, carrying the raw bytes as
//      application/octet-stream.
//   3. `uploadEnd` with [jobId, inputId]. The server finalizes the temp
//      files and sets input$<inputId> itself — no client-side value.
//
// XHR, not fetch: upload progress events on fetch still require duplex
// request streams (Chromium-only); xhr.upload.onprogress is the portable
// mechanism, and xhr.abort() gives cancellation for free.

// A progress checkpoint. Files upload one at a time, so `batch` is the
// only aggregate the caller needs; `loaded` is reported alongside it so a
// per-file bar does not have to reconstruct it from the batch fraction.
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
  onError?: (message: string) => void;
  onDone?: () => void;
}

interface UploaderOptions extends UploaderCallbacks {
  inputId: string;
  files: File[];
}

class Uploader {
  #inputId: string;
  #files: File[];
  #callbacks: UploaderCallbacks;
  #totalBytes: number;
  #doneBytes = 0;
  #shinyapp: ShinyApp | null = null;
  #xhr: XMLHttpRequest | null = null;
  #cancelled = false;
  #finished = false;

  constructor(options: UploaderOptions) {
    const { inputId, files, ...callbacks } = options;

    this.#inputId = inputId;
    this.#files = files;
    this.#callbacks = callbacks;
    this.#totalBytes = files.reduce((total, file) => total + file.size, 0);
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

    let job: UploadInitValue;

    try {
      job = await this.#uploadInit();
    } catch (error) {
      this.#fail(messageOf(error));
      return;
    }

    if (this.#isCancelled()) {
      return;
    }

    for (const file of this.#files) {
      this.#progress(file, 0, this.#fraction(this.#doneBytes));

      try {
        await this.#post(job.uploadUrl, file);
      } catch (error) {
        this.#fail(messageOf(error));
        return;
      }

      if (this.#isCancelled()) {
        return;
      }

      this.#doneBytes += file.size;
      this.#callbacks.onFileDone?.(file);
    }

    try {
      await this.#uploadEnd(job.jobId);
    } catch (error) {
      this.#fail(messageOf(error));
      return;
    }

    if (this.#isCancelled()) {
      return;
    }

    this.#progress(null, 0, 1);
    this.#finish();
  }

  // Abandons the batch: the in-flight POST is aborted and `uploadEnd`
  // never runs, so the server never sets input$<id>. The session cleans up
  // the orphaned upload operation and its temp files.
  cancel(): void {
    if (this.#finished) {
      return;
    }

    this.#cancelled = true;
    this.#finished = true;
    this.#xhr?.abort();
    this.#xhr = null;
  }

  #uploadInit(): Promise<UploadInitValue> {
    const info = this.#files.map((file) => ({
      name: file.name,
      size: file.size,
      type: file.type,
    }));

    return this.#request('uploadInit', [info]) as Promise<UploadInitValue>;
  }

  #uploadEnd(jobId: string): Promise<unknown> {
    return this.#request('uploadEnd', [jobId, this.#inputId]);
  }

  // Only reachable after run() has resolved and stored the connected app.
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

  #post(url: string, file: File): Promise<void> {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();

      this.#xhr = xhr;

      xhr.open('POST', url, true);
      xhr.setRequestHeader('Content-Type', 'application/octet-stream');

      xhr.upload.onprogress = (event) => {
        if (event.lengthComputable) {
          this.#progress(
            file,
            event.loaded,
            this.#fraction(this.#doneBytes + event.loaded),
          );
        }
      };

      xhr.onload = () => {
        this.#xhr = null;

        if (xhr.status >= 200 && xhr.status < 300) {
          resolve();
        } else {
          reject(
            new Error(xhr.responseText || `Upload failed (${xhr.status})`),
          );
        }
      };

      xhr.onerror = () => {
        this.#xhr = null;
        reject(new Error('Upload failed.'));
      };

      // cancel() aborts the request. Resolving unwinds run(), whose
      // post-await cancellation check stops the batch without an error.
      xhr.onabort = () => {
        this.#xhr = null;
        resolve();
      };

      xhr.send(file);
    });
  }

  // Read through a call, not the field: cancel() runs between the awaits
  // in run(), which control-flow narrowing of a plain field read cannot
  // account for.
  #isCancelled(): boolean {
    return this.#cancelled;
  }

  #fraction(bytes: number): number {
    return this.#totalBytes > 0 ? bytes / this.#totalBytes : 0;
  }

  #progress(file: File | null, loaded: number, batch: number): void {
    this.#callbacks.onProgress?.({
      file,
      loaded,
      batch: Math.min(Math.max(batch, 0), 1),
    });
  }

  #fail(message: string): void {
    if (this.#finished) {
      return;
    }

    this.#finished = true;
    this.#callbacks.onError?.(message);
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

export { Uploader };
export type { UploadProgress, UploaderCallbacks, UploaderOptions };
