import { LitElement, html, nothing } from 'lit'

// A choice rendered as a chip (or offered in a dropdown): `label` is
// shown, `value` is reported. Shared by the chip group and multi select.
interface ChipData {
  label: string
  value: string
}

// A single chip. `value` is the chip's identity (used in events); `label`
// is the rendered text and falls back to the value.
//
// Two optional behaviors, both owner-controlled (the chip never mutates its
// own state — keeping changes synchronous and owner-controlled is what
// prevents the old fadeOut-vs-value-report race):
//
// - checkable: clicking the chip (or Enter/Space) requests a toggle via a
//   bubbling `bsides-chip:toggle`; the owner flips `checked`. The chip
//   presents as a toggle button (role="button" + aria-pressed).
// - removable: the close button requests removal via `bsides-chip:remove`.
//
// `type` names a Bootstrap theme color: the chip carries a constant
// `chip-{type}` class and the stylesheet derives the look from the
// reflected `checked`/`checkable` attributes (solid fill when checked,
// themed border when checkable and unchecked).
class BsidesChip extends LitElement {
  static override properties = {
    value: { type: String },
    label: { type: String },
    checkable: { type: Boolean, reflect: true },
    checked: { type: Boolean, reflect: true },
    type: { type: String },
    removable: { type: Boolean, reflect: true },
    disabled: { type: Boolean, reflect: true }
  }

  // Reactive properties: `declare` + constructor defaults, because class
  // fields under useDefineForClassFields would shadow Lit's accessors.
  declare value: string
  declare label: string
  declare checkable: boolean
  declare checked: boolean
  declare type: string
  declare removable: boolean
  declare disabled: boolean

  #appliedType = ''

  constructor() {
    super()
    this.value = ''
    this.label = ''
    this.checkable = false
    this.checked = false
    this.type = ''
    this.removable = false
    this.disabled = false

    this.addEventListener('click', this.#onClick)
    this.addEventListener('keydown', this.#onKeydown)
  }

  // Render into light DOM so Bootstrap variables and the bsides theme apply.
  override createRenderRoot(): this {
    return this
  }

  // Host attributes and theme classes depend on reactive properties, so
  // they are (re)applied after every update.
  override updated(): void {
    if (this.checkable) {
      this.setAttribute('role', 'button')
      this.setAttribute('tabindex', this.disabled ? '-1' : '0')
      this.setAttribute('aria-pressed', this.checked ? 'true' : 'false')
    } else {
      this.removeAttribute('aria-pressed')
    }

    this.#applyType()
  }

  // The class is constant per type; checked/unchecked looks are derived in
  // CSS from the reflected attributes.
  #applyType(): void {
    if (this.#appliedType && this.#appliedType !== this.type) {
      this.classList.remove(`chip-${this.#appliedType}`)
    }

    this.#appliedType = this.type

    if (this.type) {
      this.classList.add(`chip-${this.type}`)
    }
  }

  override render(): unknown {
    const label = this.label || this.value

    // The leading check marks the checked state without relying on color
    // alone; aria-pressed carries the state for assistive tech.
    return html`${this.checked
      ? html`<svg
          class="chip-check"
          viewBox="0 0 16 16"
          width="1em"
          height="1em"
          fill="none"
          stroke="currentColor"
          stroke-width="2.5"
          stroke-linecap="round"
          stroke-linejoin="round"
          aria-hidden="true"
        >
          <path d="M3 8.5 6.5 12 13 4.5" />
        </svg>`
      : nothing}${label}${this.removable
      ? html`<button
          type="button"
          class="btn-close"
          aria-label=${`Remove ${label}`}
          ?disabled=${this.disabled}
          @click=${this.#onRemoveClick}
        ></button>`
      : nothing}`
  }

  #onClick = (event: Event): void => {
    if (!this.checkable || this.disabled) {
      return
    }

    // The close button means removal, not toggling.
    if ((event.target as HTMLElement).closest('.btn-close')) {
      return
    }

    this.#requestToggle()
  }

  #onKeydown = (event: KeyboardEvent): void => {
    if (!this.checkable || this.disabled || event.target !== this) {
      return
    }

    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault()
      this.#requestToggle()
    }
  }

  #requestToggle(): void {
    this.dispatchEvent(
      new CustomEvent('bsides-chip:toggle', {
        detail: { value: this.value },
        bubbles: true
      })
    )
  }

  #onRemoveClick = (): void => {
    this.dispatchEvent(
      new CustomEvent('bsides-chip:remove', {
        detail: { value: this.value },
        bubbles: true
      })
    )
  }
}

customElements.define('bsides-chip', BsidesChip)

declare global {
  interface HTMLElementTagNameMap {
    'bsides-chip': BsidesChip
  }

  interface GlobalEventHandlersEventMap {
    'bsides-chip:remove': CustomEvent<{ value: string }>
    'bsides-chip:toggle': CustomEvent<{ value: string }>
  }
}

export { BsidesChip }
export type { ChipData }
