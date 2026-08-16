import { LitElement, html, nothing } from 'lit';
import { ifDefined } from 'lit/directives/if-defined.js';
import { repeat } from 'lit/directives/repeat.js';

import { Uploader } from '../upload';

// Message shape sent by update_file() on the R side. The value itself is
// never among these: the server sets input$<id> at uploadEnd, so there is
// nothing for the client to set.
interface FileUpdate {
  reset?: boolean;
  accept?: string;
  placeholder?: string;
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
    placeholder: { type: String },
    disabled: { type: Boolean, reflect: true },
    maxSize: { type: Number, attribute: 'data-max-size' },
    _items: { state: true },
    _error: { state: true },
    _announcement: { state: true },
    _batch: { state: true },
    _uploading: { state: true },
  };

  declare multiple: boolean;
  declare accept: string;
  declare capture: string;
  declare placeholder: string;
  declare disabled: boolean;
  declare maxSize: number | null;
  declare _items: FileItem[];
  declare _error: string;
  declare _announcement: string;
  declare _batch: number;
  declare _uploading: boolean;

  // The batch in flight, if any. One at a time: a new selection cancels
  // and restarts, matching "the selection is the value" semantics.
  #uploader: Uploader | null = null;

  constructor() {
    super();
    this.multiple = false;
    this.accept = '';
    this.capture = '';
    this.placeholder = 'Choose a file';
    this.disabled = false;
    this.maxSize = null;
    this._items = [];
    this._error = '';
    this._announcement = '';
    this._batch = 0;
    this._uploading = false;
  }

  override createRenderRoot(): this {
    return this;
  }

  override disconnectedCallback(): void {
    super.disconnectedCallback();
    this.#uploader?.cancel();
    this.#uploader = null;
  }

  override render(): unknown {
    return html`
      <div class="file-dropzone" @click=${this.#onDropzoneClick}>
        <!-- The real, focusable control, visually hidden by the SCSS so
             native keyboard and screen reader behavior survive.
             data-shiny-no-bind-input is required: Shiny's own file input
             binding finds every input[type="file"] and would otherwise
             attach its uploader, and its progress markup, to this one. -->
        <input
          type="file"
          class="file-input"
          ?multiple=${this.multiple}
          accept=${ifDefined(this.accept || undefined)}
          capture=${ifDefined(this.capture || undefined)}
          ?disabled=${this.disabled || this._uploading}
          data-shiny-no-bind-input
          @change=${this.#onChange}
        />
        <span class="file-prompt">${this.placeholder}</span>
      </div>
      ${this.#renderList()} ${this.#renderBatch()}
      <p class="file-errors" role="alert">${this._error}</p>
      <span class="visually-hidden" aria-live="polite"
        >${this._announcement}</span
      >
    `;
  }

  #renderList(): unknown {
    if (this._items.length === 0) {
      return nothing;
    }

    return html`
      <ul class="file-list" role="list">
        ${repeat(
          this._items,
          (item) => item.file,
          (item) => html`
            <li class="file-item ${item.status}">
              <span class="file-item-name">${item.file.name}</span>
              <span class="file-item-size">${formatSize(item.file.size)}</span>
              ${this.#renderProgress(
                'file-item-progress',
                item.progress,
                `${item.file.name} upload progress`,
              )}
            </li>
          `,
        )}
      </ul>
    `;
  }

  // Batch progress and the cancel control, both meaningful only while a
  // batch is in flight.
  #renderBatch(): unknown {
    if (!this._uploading) {
      return nothing;
    }

    return html`
      <div class="file-batch">
        ${this.#renderProgress(
          'file-batch-progress',
          this._batch,
          'Upload progress',
        )}
        <button type="button" class="file-cancel" @click=${this.#onCancel}>
          Cancel
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
    if (this.disabled || this._uploading) {
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

  #onCancel = (): void => {
    this.#uploader?.cancel();
    this.#uploader = null;
    this._uploading = false;
    this._items = this._items.map((item) =>
      item.status === 'done' ? item : { ...item, status: 'error' as const },
    );
    this.#announce('Upload cancelled');
  };

  // Starts a batch, replacing any batch already in flight.
  upload(files: File[]): void {
    this.#uploader?.cancel();

    this._error = '';
    this._batch = 0;
    this._uploading = true;
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
      },
      onFileDone: (file) => {
        this.#updateItem(file, { status: 'done', progress: 1 });
      },
      onError: (message) => {
        this.#uploader = null;
        this._uploading = false;
        this._error = message;
        this._items = this._items.map((item) =>
          item.status === 'done' ? item : { ...item, status: 'error' as const },
        );
        this.#announce(message);
      },
      onDone: () => {
        this.#uploader = null;
        this._uploading = false;
        this._batch = 1;
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
    this._items = [];
    this._error = '';
    this._batch = 0;
    this._uploading = false;

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
  override updated(changed: Map<string, unknown>): void {
    if (changed.has('_uploading')) {
      if (this._uploading) {
        this.setAttribute('aria-busy', 'true');
      } else {
        this.removeAttribute('aria-busy');
      }
    }
  }
}

// Decimal units, matching how shiny.maxRequestSize is written (5e6 is
// "5 MB").
function formatSize(bytes: number): string {
  const units = ['B', 'kB', 'MB', 'GB', 'TB'];

  let size = bytes;
  let unit = 0;

  while (size >= 1000 && unit < units.length - 1) {
    size = size / 1000;
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
