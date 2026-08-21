import { LitElement, html, nothing } from 'lit';
import { ifDefined } from 'lit/directives/if-defined.js';
import { repeat } from 'lit/directives/repeat.js';

import { Uploader } from '../upload';
import type { FormSubmitDetail } from '../inputForm';
import { validateFiles } from '../fileValidate';
import type { Rejection } from '../fileValidate';

// Message shape sent by update_file() on the R side. The value itself is
// never among these: the server sets input$<id> at uploadEnd, so there is
// nothing for the client to set.
interface FileUpdate {
  reset?: boolean;
  accept?: string;
  placeholder?: string;
  summary?: string;
  // Action triggers, sent by file_upload_start()/file_upload_cancel();
  // snake_case mirrors those function names across the boundary.
  upload_start?: boolean;
  upload_cancel?: boolean;
  enable?: boolean;
  disable?: boolean;
}

type ItemStatus = 'pending' | 'uploading' | 'done' | 'error';

interface FileItem {
  file: File;
  status: ItemStatus;
  // Fraction of this file's bytes sent, in [0, 1].
  progress: number;
}

// The status companion's vocabulary, held outright rather than derived:
// the current set ("idle"/"staged") and the last batch's outcome
// ("done", "failed", "cancelled") are orthogonal, and the rows alone
// cannot answer the second — whatever happened next overwrote them.
// Assigned at every transition.
type Phase = 'idle' | 'staged' | 'uploading' | 'done' | 'failed' | 'cancelled';

// What the .file-errors list and the error companion report, from one
// source so the two cannot drift. Rejections carry the per-file records
// validation produced; a transport failure has only the Uploader's
// message.
type Failure =
  | { kind: 'rejection'; rejections: Rejection[] }
  | { kind: 'failure'; message: string };

// The file input element. It owns the picker, the list of selected files,
// and the upload lifecycle; the binding beside it (inputFile.ts) only
// relays server messages.
//
// Uploads do not travel through the input value. Shiny's protocol ends
// with the server writing input$<id> itself, so this element never
// reports a value and never needs to.
class BsidesFile extends LitElement {
  static override properties = {
    multiple: { type: Boolean, reflect: true },
    accept: { type: String, reflect: true },
    capture: { type: String, reflect: true },
    mode: { type: String, reflect: true },
    placeholder: { type: String },
    summary: { type: String },
    disabled: { type: Boolean, reflect: true },
    maxSize: { type: Number, attribute: 'data-max-size' },
    _items: { state: true },
    _listOpen: { state: true },
    _failure: { state: true },
    _dragover: { state: true },
    _announcement: { state: true },
    _batch: { state: true },
    _phase: { state: true },
  };

  declare multiple: boolean;
  declare accept: string;
  declare capture: string;
  declare mode: string;
  declare placeholder: string;
  declare summary: string;
  declare disabled: boolean;
  declare maxSize: number | null;
  declare _items: FileItem[];
  declare _listOpen: boolean;
  declare _failure: Failure | null;
  declare _dragover: boolean;
  declare _announcement: string;
  declare _batch: number;
  declare _phase: Phase;

  // The batch in flight, if any. One at a time: a new selection cancels
  // and restarts, matching "the selection is the value" semantics.
  #uploader: Uploader | null = null;

  // dragenter/dragleave fire for every descendant a drag crosses, so the
  // hover state counts entries rather than trusting a single leave.
  #dragDepth = 0;

  // The form ancestor being listened to for bsides-form:submit, held so
  // disconnection can unhook exactly what connection hooked.
  #form: HTMLFormElement | null = null;

  // The batch in flight, as a promise a form can await. Uploader.run()
  // resolves for every ending — completion, error, cancellation — so
  // success is only distinguishable through the callbacks, which settle
  // this instead. Held on the instance because it is created in
  // #start(), settled from those callbacks, and read by #onFormSubmit().
  #batchPromise: Promise<void> | null = null;
  #batchSettle: {
    resolve: () => void;
    reject: (reason: Error) => void;
  } | null = null;

  // Trailing-edge throttle for the progress companion — progress events
  // fire per XHR tick, far faster than the server wants them.
  #progressPending = 0;
  #progressTimer: number | null = null;

  constructor() {
    super();
    this.multiple = false;
    this.accept = '';
    this.capture = '';
    this.mode = 'auto';
    this.placeholder = 'Choose a file';
    this.summary = '{files} · {size}';
    this.disabled = false;
    this.maxSize = null;
    this._items = [];
    this._listOpen = true;
    this._failure = null;
    this._dragover = false;
    this._announcement = '';
    this._batch = 0;
    this._phase = 'idle';
  }

  override createRenderRoot(): this {
    return this;
  }

  // A staged set inside input_form() uploads on the form's submit,
  // landing the value alongside the replayed frozen values. The hook is
  // the form binding's bsides-form:submit event; the guards in
  // #onUpload() make this a no-op outside manual mode or with nothing
  // staged.
  override connectedCallback(): void {
    super.connectedCallback();
    this.#form = this.closest('form');
    this.#form?.addEventListener('bsides-form:submit', this.#onFormSubmit);
  }

  override disconnectedCallback(): void {
    super.disconnectedCallback();
    this.#form?.removeEventListener('bsides-form:submit', this.#onFormSubmit);
    this.#form = null;
    this.#uploader?.cancel();
    this.#uploader = null;
  }

  #onFormSubmit = (event: Event): void => {
    // A no-op outside manual mode, with nothing staged, or with a batch
    // already running — and that last case is the point: the batch in
    // flight is handed back below rather than declined, so a submit
    // arriving mid-upload waits for it instead of racing it.
    this.#onUpload();

    if (this.#batchPromise) {
      (event as CustomEvent<FormSubmitDetail>).detail.waitUntil(
        this.#batchPromise,
      );
    }
  };

  #openBatch(): void {
    this.#batchPromise = new Promise<void>((resolve, reject) => {
      this.#batchSettle = { resolve, reject };
    });

    // Nobody need be awaiting — an upload started from the component's
    // own button has no form behind it. Mark the rejection handled so a
    // failed batch is not also reported as an unhandled rejection.
    void this.#batchPromise.catch(() => undefined);
  }

  #settleBatch(failure?: Error): void {
    const settle = this.#batchSettle;

    this.#batchSettle = null;
    this.#batchPromise = null;

    if (!settle) {
      return;
    }

    if (failure) {
      settle.reject(failure);
    } else {
      settle.resolve();
    }
  }

  // Render guards and gesture checks need only the boolean.
  get #uploading(): boolean {
    return this._phase === 'uploading';
  }

  override render(): unknown {
    return html`
      <div
        class="file-dropzone${this._dragover ? ' dragover' : ''}"
        @click=${this.#onDropzoneClick}
        @dragenter=${this.#onDragEnter}
        @dragover=${this.#onDragOver}
        @dragleave=${this.#onDragLeave}
        @drop=${this.#onDrop}
        @paste=${this.#onPaste}
      >
        <input
          type="file"
          class="file-input"
          ?multiple=${this.multiple}
          accept=${ifDefined(this.accept || undefined)}
          capture=${ifDefined(this.capture || undefined)}
          ?disabled=${this.disabled || this.#uploading}
          data-shiny-no-bind-input
          @change=${this.#onChange}
        />
        <span class="file-prompt">${this.placeholder}</span>
      </div>
      ${this.#renderBatch()} ${this.#renderList()}
      <p class="file-errors" role="alert">
        ${this.#failureMessages().map(
          (message) => html`<span class="file-error">${message}</span>`,
        )}
      </p>
      <span class="visually-hidden" aria-live="polite"
        >${this._announcement}</span
      >
    `;
  }

  #renderList(): unknown {
    if (this._items.length === 0) {
      return nothing;
    }

    // A one-file batch has nothing to break down: its per-file bar and the
    // batch bar above carry the same number, so only the batch bar renders.
    const perFile = this._items.length > 1;

    const count = this._items.length;
    const total = this._items.reduce((sum, item) => sum + item.file.size, 0);

    const summaryText = interpolate(this.summary, {
      n: String(count),
      files: count === 1 ? '1 file' : `${count} files`,
      size: formatSize(total),
      done: String(this._items.filter((item) => item.status === 'done').length),
      failed: String(
        this._items.filter((item) => item.status === 'error').length,
      ),
      percent: String(Math.round(this._batch * 100)),
    });

    return html`
      <details
        class="file-disclosure"
        ?open=${this._listOpen}
        @toggle=${this.#onListToggle}
      >
        <summary class="file-summary">${summaryText}</summary>
        <ul class="file-list" role="list">
          ${repeat(
            this._items,
            (item) => item.file,
            (item) => html`
            <li class="file-item ${item.status}">
              <span class="file-item-name">${item.file.name}</span>
              <span class="file-item-size">${formatSize(item.file.size)}</span>
              ${
                this.#removable(item)
                  ? html`<button
                      type="button"
                      class="file-item-remove btn-close"
                      aria-label="Remove ${item.file.name}"
                      @click=${() => this.#onRemove(item)}
                    ></button>`
                  : nothing
              }
              ${
                perFile
                  ? this.#renderProgress(
                      'file-item-progress',
                      item.progress,
                      `${item.file.name} upload progress`,
                    )
                  : nothing
              }
            </li>
            `,
          )}
        </ul>
      </details>
    `;
  }

  // Batch controls: progress and Cancel while a batch is in flight. In
  // manual mode the row is permanent — the Upload button, disabled until
  // something is staged, is the affordance that says a second action is
  // coming. Auto mode at rest renders nothing, as before.
  #renderBatch(): unknown {
    if (this.#uploading) {
      return html`
        <div class="file-batch">
          ${this.#renderProgress(
            'file-batch-progress',
            this._batch,
            'Upload progress',
          )}
          <button
            type="button"
            class="btn btn-danger btn-sm file-cancel"
            @click=${this.#onCancel}
          >
            Cancel
          </button>
        </div>
      `;
    }

    if (this.mode !== 'manual') {
      return nothing;
    }

    return html`
      <div class="file-batch">
        <button
          type="button"
          class="btn btn-primary btn-sm file-upload"
          ?disabled=${this.disabled || this.#stagedFiles().length === 0}
          @click=${this.#onUpload}
        >
          Upload
        </button>
      </div>
    `;
  }

  // Progress as an inline custom property rather than a nested bar with a
  // width: the markup stays flat and the SCSS owns the visual.
  #renderProgress(className: string, fraction: number, label: string): unknown {
    const percent = Math.round(fraction * 100);

    return html`<span
      class=${className}
      role="progressbar"
      aria-label=${label}
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow=${percent}
      style="--bsides-file-progress: ${percent}%"
    ></span>`;
  }

  // Apply a server update (update_file() → receiveMessage() → here).
  receiveUpdate(msg: FileUpdate): void {
    if (msg.reset === true) {
      this.#reset();
    }

    if (msg.accept !== undefined) {
      this.accept = msg.accept;
    }

    if (msg.placeholder !== undefined) {
      this.placeholder = msg.placeholder;
    }

    if (msg.summary !== undefined) {
      this.summary = msg.summary;
    }

    if (msg.upload_start === true) {
      this.#onUpload();
    }

    if (msg.upload_cancel === true) {
      this.#onCancel();
    }

    // Two one-way switches; when both arrive, disable wins.
    if (msg.enable === true) {
      this.disabled = false;
    }

    if (msg.disable === true) {
      this.disabled = true;
    }
  }

  get #inputElement(): HTMLInputElement | null {
    return this.querySelector<HTMLInputElement>('.file-input');
  }

  // The dropzone forwards clicks to the real input. Clicks landing on the
  // input itself already open the picker; forwarding them would open it
  // twice.
  #onDropzoneClick = (event: Event): void => {
    if (this.disabled || this.#uploading) {
      return;
    }

    if (event.target !== this.#inputElement) {
      this.#inputElement?.click();
    }
  };

  #onChange = (event: Event): void => {
    const input = event.target as HTMLInputElement;
    const files = Array.from(input.files ?? []);

    // Release the picker's selection now that the File objects are held:
    // picking the same file again then still fires `change`.
    input.value = '';

    if (files.length > 0) {
      this.upload(files);
    }
  };

  #acceptsFiles(): boolean {
    return !this.disabled && !this.#uploading;
  }

  #onDragEnter = (event: DragEvent): void => {
    if (!this.#acceptsFiles()) {
      return;
    }

    event.preventDefault();
    this.#dragDepth++;
    this._dragover = true;
  };

  #onDragOver = (event: DragEvent): void => {
    if (!this.#acceptsFiles()) {
      return;
    }

    // Without this the browser treats the drop as navigation and opens
    // the file.
    event.preventDefault();

    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = 'copy';
    }
  };

  #onDragLeave = (): void => {
    this.#dragDepth = Math.max(this.#dragDepth - 1, 0);

    if (this.#dragDepth === 0) {
      this._dragover = false;
    }
  };

  #onDrop = (event: DragEvent): void => {
    if (!this.#acceptsFiles()) {
      return;
    }

    event.preventDefault();
    this.#dragDepth = 0;
    this._dragover = false;

    if (!event.dataTransfer) {
      return;
    }

    const { files, directories } = readTransfer(event.dataTransfer);

    if (files.length === 0 && directories.length === 0) {
      return;
    }

    this.upload(
      files,
      directories.map((name) => ({
        name,
        reason: { kind: 'directory' as const },
      })),
    );
  };

  // Pasting a screenshot is a file drop by another route; jsdom aside,
  // clipboardData.files carries it.
  #onPaste = (event: ClipboardEvent): void => {
    if (!this.#acceptsFiles()) {
      return;
    }

    const files = Array.from(event.clipboardData?.files ?? []);

    if (files.length === 0) {
      return;
    }

    event.preventDefault();
    this.upload(files);
  };

  // <details open> is DOM state; bind it to _listOpen and sync back here
  // so a mid-upload re-render cannot clobber a user's fold.
  #onListToggle = (event: Event): void => {
    this._listOpen = (event.target as HTMLDetailsElement).open;
  };

  // Abandons the batch in flight — the Cancel button and
  // file_upload_cancel() alike, hence the guard. In manual mode every
  // row returns to pending: nothing failed, the set is still staged,
  // and the retry re-POSTs from the first byte, so progress goes back
  // to 0 with the status. Auto mode marks non-done rows as failed, as
  // before — it has no staged set to return to.
  #onCancel = (): void => {
    if (!this.#uploading) {
      return;
    }

    this.#uploader?.cancel();
    this.#uploader = null;
    this.#settleBatch(new Error('Upload cancelled.'));
    this._phase = this.mode === 'manual' ? 'staged' : 'cancelled';
    this.#pushProgressFinal(0);
    this._items = this._items.map((item) => {
      if (this.mode === 'manual') {
        return { ...item, status: 'pending' as const, progress: 0 };
      }

      return item.status === 'done'
        ? item
        : { ...item, status: 'error' as const };
    });
    this.#announce('Upload cancelled');
  };

  // The single entry for every gesture (pick, drop, paste): validates a
  // set of files and hands the survivors to the mode's terminal — started
  // as a batch in auto mode, *staged without uploading* in manual mode,
  // the name notwithstanding. Files arriving by drop or paste never
  // passed the picker's own filtering, so `accept` and `multiple` are
  // enforced here as well as by the picker.
  //
  // `rejected` carries checks the caller already made — dropped folders,
  // which only a DataTransfer can identify.
  upload(files: File[], rejected: Rejection[] = []): void {
    const rejections = [...rejected];

    // Silently keeping the first file would read as data loss. A
    // gesture-level rule, recorded against every file in the gesture so
    // the failure record stays per-file.
    if (!this.multiple && files.length > 1) {
      rejections.push(
        ...files.map((file) => ({
          name: file.name,
          reason: { kind: 'multiple' as const },
        })),
      );
      this.#reject(rejections);
      return;
    }

    const validation = validateFiles(files, {
      accept: this.accept,
      maxSize: this.maxSize,
    });

    rejections.push(...validation.rejected);

    if (validation.accepted.length === 0) {
      this.#reject(rejections);
      return;
    }

    if (this.mode === 'manual') {
      this.#stage(validation.accepted);
    } else {
      this.#start(validation.accepted);
    }

    // After the terminals: they clear the previous failure, and a
    // partially-rejected gesture's own records must outlive that.
    this._failure =
      rejections.length > 0 ? { kind: 'rejection', rejections } : null;
  }

  // Reports a gesture that staged or started nothing. In manual mode
  // the staged set survives — the set being built is not the thing that
  // failed — and the phase stays where it was: nothing was attempted,
  // so "failed" would be a lie.
  #reject(rejections: Rejection[]): void {
    this._failure = { kind: 'rejection', rejections };

    if (this.mode !== 'manual') {
      this._items = [];
      this._phase = 'idle';
    }

    this.#announce(this.#failureMessages().join(' '));
  }

  // Adds validated files to the staged set — upload()'s manual-mode
  // terminal. A delivered batch's rows clear on the next addition: that
  // batch's value was set at uploadEnd, and keeping its rows would
  // conflate two batches in one list. A cancelled or failed batch
  // delivered nothing, leaves no done rows, and so survives additions.
  #stage(files: File[]): void {
    this._failure = null;

    let items = this._items.some((item) => item.status === 'done')
      ? []
      : this._items;

    // A set edit ends the last failure's reporting, the error marks on
    // surviving rows included — a mark outliving its message would be a
    // red row with nothing left to explain it.
    items = items.map((item) =>
      item.status === 'error' ? { ...item, status: 'pending' as const } : item,
    );

    // select = "one": a new pick replaces the staged file. Multi-file
    // gestures were already rejected whole by upload().
    if (!this.multiple) {
      items = [];
    }

    const added: string[] = [];
    const replaced: string[] = [];

    for (const file of files) {
      const index = items.findIndex((item) => item.file.name === file.name);
      const item = { file, status: 'pending' as const, progress: 0 };

      if (index >= 0) {
        // Same name replaces: re-exporting a corrected file is the
        // common case; two same-named files in one batch almost never.
        items = items.map((other, i) => (i === index ? item : other));
        replaced.push(file.name);
      } else {
        items = [...items, item];
        added.push(file.name);
      }
    }

    this._items = items;
    this._listOpen = true;
    this._phase = 'staged';

    const count = this._items.length;
    const staged = count === 1 ? '1 file staged' : `${count} files staged`;
    const parts = [
      added.length === 1 ? `${added[0]} added` : '',
      added.length > 1 ? `${added.length} files added` : '',
      replaced.length === 1 ? `${replaced[0]} replaced` : '',
      replaced.length > 1 ? `${replaced.length} files replaced` : '',
    ].filter(Boolean);

    this.#announce(`${parts.join(', ')}, ${staged}`);
  }

  // The set a manual-mode batch would send: staged rows plus any
  // carrying a failure mark from the last attempt — a retry re-sends
  // everything.
  #stagedFiles(): File[] {
    return this._items
      .filter((item) => item.status === 'pending' || item.status === 'error')
      .map((item) => item.file);
  }

  // A row can be removed while the user can still act on it: staged
  // (pending) or carrying a failure mark, with no batch in flight. A
  // done row was delivered at uploadEnd; removing it would not unsend
  // it.
  #removable(item: FileItem): boolean {
    return (
      this.mode === 'manual' &&
      !this.#uploading &&
      (item.status === 'pending' || item.status === 'error')
    );
  }

  #onRemove(item: FileItem): void {
    const index = this._items.indexOf(item);

    // A set edit ends the last failure's reporting — the message, and
    // the marks on the rows that remain.
    this._items = this._items
      .filter((other) => other !== item)
      .map((other) =>
        other.status === 'error'
          ? { ...other, status: 'pending' as const }
          : other,
      );
    this._failure = null;
    this._phase = this._items.length === 0 ? 'idle' : 'staged';

    this.#announce(`${item.file.name} removed`);

    // The control under focus was just destroyed. Land on the control
    // of the row that took this one's place, the previous row's when
    // this one was last, or the (visually hidden, still focusable)
    // picker once the list is empty — the Upload button is disabled at
    // zero staged files and a disabled button takes no focus. Queried
    // after the update: repeat() keys rows by File, so surviving rows
    // keep their nodes and move.
    void this.updateComplete.then(() => {
      const controls = [
        ...this.querySelectorAll<HTMLButtonElement>('.file-item-remove'),
      ];
      const target =
        controls.at(index) ?? controls.at(index - 1) ?? this.#inputElement;

      target?.focus();
    });
  }

  // The Upload button, and the retry entry after a cancel or a failure.
  #onUpload = (): void => {
    const files = this.#stagedFiles();

    if (this.mode !== 'manual' || files.length === 0 || this.#uploading) {
      return;
    }

    this.#start(files);
  };

  #start(files: File[]): void {
    this.#uploader?.cancel();
    this.#settleBatch(new Error('Upload restarted.'));
    this.#openBatch();

    // A new flight ends the previous attempt's reporting — the message
    // must not outlive the attempt it reports.
    this._failure = null;
    this.#pushProgressFinal(0);

    this._batch = 0;
    this._phase = 'uploading';
    this._listOpen = true;
    this._items = files.map((file) => ({
      file,
      status: 'pending' as const,
      progress: 0,
    }));

    this.#announce(
      files.length === 1
        ? `Uploading ${files[0].name}`
        : `Uploading ${files.length} files`,
    );

    const uploader = new Uploader({
      inputId: this.id,
      files,
      onProgress: ({ file, loaded, batch }) => {
        this._batch = batch;

        if (file) {
          this.#updateItem(file, {
            status: 'uploading',
            progress: file.size > 0 ? loaded / file.size : 1,
          });
        }

        // App authors hook progress here rather than through an API of
        // our own invention.
        this.dispatchEvent(
          new CustomEvent('bsides-file:progress', {
            bubbles: true,
            detail: { file, loaded, batch },
          }),
        );

        this.#pushProgress(batch);
      },
      onFileDone: (file) => {
        this.#updateItem(file, { status: 'done', progress: 1 });
      },
      // In manual mode a failure lands where a cancel lands: uploadEnd
      // never ran, so nothing was delivered and the set is still the
      // value. Only the row in flight when the batch died keeps an
      // error mark — the one diagnostic the user gets, since the
      // Uploader reports just a message. Auto mode keeps its terminal
      // marking.
      onError: (message) => {
        this.#uploader = null;
        this.#settleBatch(new Error(message));
        this._phase = 'failed';
        this._failure = { kind: 'failure', message };
        this.#pushProgressFinal(0);
        this._items = this._items.map((item) => {
          if (this.mode === 'manual') {
            const status: ItemStatus =
              item.status === 'uploading' ? 'error' : 'pending';

            return { ...item, status, progress: 0 };
          }

          return item.status === 'done'
            ? item
            : { ...item, status: 'error' as const };
        });
        this.#announce(message);
      },
      onDone: () => {
        this.#uploader = null;
        this.#settleBatch();
        this._phase = 'done';
        this._batch = 1;
        this.#pushProgressFinal(1);
        this.#announce(
          files.length === 1
            ? `${files[0].name} uploaded`
            : `${files.length} files uploaded`,
        );
      },
    });

    this.#uploader = uploader;

    void uploader.run();
  }

  #updateItem(file: File, changes: Partial<FileItem>): void {
    this._items = this._items.map((item) =>
      item.file === file ? { ...item, ...changes } : item,
    );
  }

  #reset(): void {
    this.#uploader?.cancel();
    this.#uploader = null;
    this.#settleBatch(new Error('Upload reset.'));
    this.#pushProgressFinal(0);
    this._items = [];
    this._listOpen = true;
    this._failure = null;
    this._dragover = false;
    this._batch = 0;
    this._phase = 'idle';

    const input = this.#inputElement;

    if (input) {
      input.value = '';
    }
  }

  #announce(message: string): void {
    this._announcement = message;
  }

  // Marks the whole component busy while bytes are in transit. Set on the
  // host, which render() cannot reach: this element renders into light DOM
  // and so owns its children, not its own attributes.
  //
  // Also the single choke point for the status/staged/error companion
  // inputs: every state change lands here once per render, so the
  // pushes cannot drift from what the user sees. Shiny's send-side
  // dedupe drops repeats, and progress pushes separately (throttled)
  // from onProgress.
  override updated(changed: Map<string, unknown>): void {
    if (changed.has('_phase')) {
      if (this.#uploading) {
        this.setAttribute('aria-busy', 'true');
      } else {
        this.removeAttribute('aria-busy');
      }
    }

    this.#push('status', this._phase);
    this.#push(
      'staged:bsides.file.staged',
      this.mode === 'manual'
        ? this.#stagedFiles().map((file) => ({
            name: file.name,
            size: file.size,
            type: file.type,
          }))
        : [],
    );
    this.#push('error:bsides.file.error', this.#failurePayload());
  }

  // The rendered sentences — the .file-errors list and the condition's
  // message, from one source. Gesture-level rejections repeat one
  // sentence across their files; the display collapses the duplicates
  // while the records stay per-file.
  #failureMessages(): string[] {
    if (this._failure === null) {
      return [];
    }

    if (this._failure.kind === 'failure') {
      return [this._failure.message];
    }

    return [...new Set(this._failure.rejections.map(rejectionMessage))];
  }

  // The error companion's payload, turned into a condition object by
  // the bsides.file.error input handler: kind picks the condition's
  // class, messages its message, files its per-file record frame —
  // empty when the failure names no file.
  #failurePayload(): unknown {
    if (this._failure === null) {
      return null;
    }

    const files =
      this._failure.kind === 'rejection'
        ? this._failure.rejections.map((rejection) => ({
            name: rejection.name,
            reason: rejection.reason.kind,
            limit: 'limit' in rejection.reason ? rejection.reason.limit : null,
          }))
        : [];

    return {
      kind: this._failure.kind,
      messages: this.#failureMessages(),
      files,
    };
  }

  #push(suffix: string, value: unknown): void {
    if (this.id) {
      window.Shiny?.setInputValue?.(`${this.id}__bsides_${suffix}`, value);
    }
  }

  #pushProgress(fraction: number): void {
    this.#progressPending = fraction;

    if (this.#progressTimer === null) {
      this.#progressTimer = window.setTimeout(() => {
        this.#progressTimer = null;
        this.#push('progress', this.#progressPending);
      }, 150);
    }
  }

  // A batch ended: the throttle stops waiting and the final value —
  // 1 delivered, 0 abandoned — goes out immediately.
  #pushProgressFinal(fraction: number): void {
    if (this.#progressTimer !== null) {
      window.clearTimeout(this.#progressTimer);
      this.#progressTimer = null;
    }

    this.#push('progress', fraction);
  }
}

// Fills {token} slots in the summary template from upload state. Unknown
// tokens render verbatim: a typo like {sise} stays visible in the page
// instead of vanishing silently. The result lands in a Lit text binding,
// so no HTML surface exists regardless of the template.
function interpolate(template: string, vars: Record<string, string>): string {
  return template.replace(/\{([a-z_]+)\}/g, (match, key: string) =>
    key in vars ? vars[key] : match,
  );
}

// A dropped folder yields File objects that fail opaquely mid-POST;
// webkitGetAsEntry is the only way to tell a folder from a file before
// then, and only a DataTransfer offers it.
function readTransfer(transfer: DataTransfer): {
  files: File[];
  directories: string[];
} {
  const files: File[] = [];
  const directories: string[] = [];

  for (const item of Array.from(transfer.items)) {
    if (item.kind !== 'file') {
      continue;
    }

    const entry = item.webkitGetAsEntry();

    if (entry?.isDirectory) {
      directories.push(entry.name);
      continue;
    }

    const file = item.getAsFile();

    if (file) {
      files.push(file);
    }
  }

  return { files, directories };
}

function rejectionMessage(rejection: Rejection): string {
  switch (rejection.reason.kind) {
    case 'size':
      return `${rejection.name} is larger than the ${formatSize(
        rejection.reason.limit,
      )} upload limit.`;
    case 'accept':
      return `${rejection.name} is not an accepted file type.`;
    case 'directory':
      return `${rejection.name} is a folder, and folders cannot be uploaded.`;
    case 'multiple':
      return 'Only one file may be uploaded.';
  }
}

// Binary steps under decimal labels, the convention shiny.maxRequestSize
// is written in: its 5 * 1024 * 1024 default is "5 MB" everywhere it is
// documented, and the limit is what this formats most often.
function formatSize(bytes: number): string {
  const units = ['B', 'kB', 'MB', 'GB', 'TB'];

  let size = bytes;
  let unit = 0;

  while (size >= 1024 && unit < units.length - 1) {
    size = size / 1024;
    unit++;
  }

  const rounded = unit === 0 ? size : Math.round(size * 10) / 10;

  return `${rounded} ${units[unit]}`;
}

customElements.define('bsides-file', BsidesFile);

declare global {
  interface HTMLElementTagNameMap {
    'bsides-file': BsidesFile;
  }

  interface GlobalEventHandlersEventMap {
    'bsides-file:progress': CustomEvent<{
      file: File | null;
      loaded: number;
      batch: number;
    }>;
  }
}

export { BsidesFile, formatSize };
export type { FileUpdate, FileItem, ItemStatus };
