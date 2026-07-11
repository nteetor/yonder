import { LitElement, html, nothing } from 'lit'

// A single removable chip. The chip's label is its value. The close button
// announces removal via a bubbling event; the chip never removes itself —
// its owner (usually <bsides-chip-group>) decides. Keeping removal
// synchronous and owner-controlled is what prevents the old
// fadeOut-vs-value-report race.
class BsidesChip extends LitElement {
  static override properties = {
    value: { type: String },
    removable: { type: Boolean, reflect: true },
    disabled: { type: Boolean, reflect: true }
  }

  // Reactive properties: `declare` + constructor defaults, because class
  // fields under useDefineForClassFields would shadow Lit's accessors.
  declare value: string
  declare removable: boolean
  declare disabled: boolean

  constructor() {
    super()
    this.value = ''
    this.removable = false
    this.disabled = false
  }

  // Render into light DOM so Bootstrap variables and the bsides theme apply.
  override createRenderRoot(): this {
    return this
  }

  override connectedCallback(): void {
    super.connectedCallback()

    if (!this.hasAttribute('role')) {
      this.setAttribute('role', 'option')
    }
  }

  override render(): unknown {
    return html`${this.value}${this.removable
      ? html`<button
          type="button"
          class="btn-close"
          aria-label=${`Remove ${this.value}`}
          ?disabled=${this.disabled}
          @click=${this.#onRemoveClick}
        ></button>`
      : nothing}`
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
  }
}

export { BsidesChip }
