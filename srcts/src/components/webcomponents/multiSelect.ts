import { LitElement, html } from 'lit'
import { ifDefined } from 'lit/directives/if-defined.js'

import './chipGroup'
import type { BsidesChipGroup } from './chipGroup'

// Free-text multi select: typed text becomes chips (Enter), chips are
// removable (close button, or Backspace in an empty input). `value` is the
// current chip set and the input's Shiny value.
//
// Reserved for later phases: `choices` (restrict selection to predefined
// options, phase 3) and `creatable` (free text alongside choices).
class BsidesMultiSelect extends LitElement {
  static override properties = {
    value: { type: Array },
    max: { type: Number },
    placeholder: { type: String },
    disabled: { type: Boolean, reflect: true },
    _announcement: { state: true }
  }

  declare value: string[]
  declare max: number | null
  declare placeholder: string
  declare disabled: boolean
  declare _announcement: string

  constructor() {
    super()
    this.value = []
    this.max = null
    this.placeholder = ''
    this.disabled = false
    this._announcement = ''

    this.addEventListener('bsides-chip-group:change', this.#onGroupChange)
  }

  override createRenderRoot(): this {
    return this
  }

  override render(): unknown {
    return html`
      <bsides-chip-group
        .chips=${this.value}
        removable
        ?disabled=${this.disabled}
        label="Selected values"
      ></bsides-chip-group>
      <input
        type="text"
        class="multi-select-input"
        placeholder=${ifDefined(this.placeholder || undefined)}
        ?disabled=${this.disabled || this.#atMax()}
        data-shiny-no-bind-input
        @keydown=${this.#onKeydown}
      />
      <span class="visually-hidden" aria-live="polite">
        ${this._announcement}
      </span>
    `
  }

  #atMax(): boolean {
    return this.max != null && this.value.length >= this.max
  }

  get #inputElement(): HTMLInputElement | null {
    return this.querySelector('.multi-select-input')
  }

  #onKeydown = (event: KeyboardEvent): void => {
    const input = event.target as HTMLInputElement

    if (event.key === 'Enter') {
      event.preventDefault()
      this.#add(input)
    } else if (event.key === 'Backspace' && input.value === '') {
      this.#removeLast()
    }
  }

  #add(input: HTMLInputElement): void {
    const text = input.value.trim()

    if (!text || this.#atMax()) {
      return
    }

    // Duplicates are rejected; the typed text stays so the collision is
    // visible.
    if (this.value.includes(text)) {
      return
    }

    this.value = [...this.value, text]
    input.value = ''
    this._announcement = `${text} added`
    this.#dispatchChange()
  }

  #removeLast(): void {
    if (this.value.length === 0) {
      return
    }

    const removed = this.value[this.value.length - 1]

    this.value = this.value.slice(0, -1)
    this._announcement = `${removed} removed`
    this.#dispatchChange()
  }

  // A chip was removed through the group (close button).
  #onGroupChange = (event: Event): void => {
    this.value = (event.target as BsidesChipGroup).chips
    this._announcement = 'Value removed'
    this.#dispatchChange()

    // Removing a chip can re-enable a maxed-out input; keep the user's
    // focus in the component.
    void this.updateComplete.then(() => {
      this.#inputElement?.focus()
    })
  }

  #dispatchChange(): void {
    void this.updateComplete.then(() => {
      this.dispatchEvent(
        new CustomEvent('bsides-multi-select:change', { bubbles: true })
      )
    })
  }
}

customElements.define('bsides-multi-select', BsidesMultiSelect)

declare global {
  interface HTMLElementTagNameMap {
    'bsides-multi-select': BsidesMultiSelect
  }

  interface GlobalEventHandlersEventMap {
    'bsides-multi-select:change': CustomEvent<void>
  }
}

export { BsidesMultiSelect }
