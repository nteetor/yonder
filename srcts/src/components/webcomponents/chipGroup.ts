import { LitElement, html } from 'lit'
import { repeat } from 'lit/directives/repeat.js'

import './chip'

// A data-driven collection of chips: `chips` is the source of truth and the
// group renders its <bsides-chip> children from it. Removal requests from
// child chips update `chips`, then a change event fires once the DOM has
// settled — so listeners always observe the post-removal state.
class BsidesChipGroup extends LitElement {
  static override properties = {
    chips: { type: Array },
    removable: { type: Boolean, reflect: true },
    disabled: { type: Boolean, reflect: true },
    label: { type: String }
  }

  declare chips: string[]
  declare removable: boolean
  declare disabled: boolean
  declare label: string

  constructor() {
    super()
    this.chips = []
    this.removable = false
    this.disabled = false
    this.label = ''

    this.addEventListener('bsides-chip:remove', this.#onChipRemove)
  }

  override createRenderRoot(): this {
    return this
  }

  override connectedCallback(): void {
    super.connectedCallback()

    if (!this.hasAttribute('role')) {
      this.setAttribute('role', 'listbox')
    }
  }

  override willUpdate(): void {
    if (this.label) {
      this.setAttribute('aria-label', this.label)
    }
  }

  override render(): unknown {
    return html`${repeat(
      this.chips,
      (chip) => chip,
      (chip) => html`<bsides-chip
        .value=${chip}
        ?removable=${this.removable}
        ?disabled=${this.disabled}
      ></bsides-chip>`
    )}`
  }

  #onChipRemove = (event: Event): void => {
    const { value } = (event as CustomEvent<{ value: string }>).detail

    this.chips = this.chips.filter((chip) => chip !== value)

    void this.updateComplete.then(() => {
      this.dispatchEvent(
        new CustomEvent('bsides-chip-group:change', { bubbles: true })
      )
    })
  }
}

customElements.define('bsides-chip-group', BsidesChipGroup)

declare global {
  interface HTMLElementTagNameMap {
    'bsides-chip-group': BsidesChipGroup
  }

  interface GlobalEventHandlersEventMap {
    'bsides-chip-group:change': CustomEvent<void>
  }
}

export { BsidesChipGroup }
