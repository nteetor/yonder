import { LitElement, html } from 'lit'
import { repeat } from 'lit/directives/repeat.js'

import './chip'
import type { ChipData } from './chip'

// Message shape sent by update_chip_group() on the R side. `select`
// replaces the checked set (shiny's convention — no merging) and may
// arrive as a bare string: Shiny serializes length-1 vectors as scalars.
// `enable`/`disable` are whole-input switches.
interface ChipGroupUpdate {
  choices?: ChipData[]
  select?: string | string[]
  enable?: boolean
  disable?: boolean
}

// The chip group input element: a checkbox group rendered as chips. Every
// choice is a chip, clicking (or Enter/Space on) a chip toggles its checked
// state, and `checked` is the input's Shiny value. Membership never
// changes from the client — chips are not removable (the multi select is
// the input for editing a set; see <bsides-multi-select>).
class BsidesChipGroup extends LitElement {
  static override properties = {
    choices: { type: Array },
    checked: { type: Array },
    type: { type: String },
    layout: { type: String, reflect: true },
    disabled: { type: Boolean, reflect: true },
    label: { type: String },
    _announcement: { state: true }
  }

  declare choices: ChipData[]
  declare checked: string[]
  declare type: string
  declare layout: 'vertical' | 'horizontal'
  declare disabled: boolean
  declare label: string
  declare _announcement: string

  constructor() {
    super()
    this.choices = []
    this.checked = []
    this.type = 'primary'
    this.layout = 'vertical'
    this.disabled = false
    this.label = ''
    this._announcement = ''

    this.addEventListener('bsides-chip:toggle', this.#onChipToggle)
  }

  override createRenderRoot(): this {
    return this
  }

  override render(): unknown {
    return html`
      <div
        class="chip-group-chips"
        role="group"
        aria-label=${this.label || 'Chips'}
      >
        ${repeat(
          this.choices,
          (choice) => choice.value,
          (choice) => html`<bsides-chip
            .value=${choice.value}
            .label=${choice.label}
            .type=${this.type}
            checkable
            ?checked=${this.checked.includes(choice.value)}
            ?disabled=${this.disabled}
          ></bsides-chip>`
        )}
      </div>
      <span class="visually-hidden" aria-live="polite">
        ${this._announcement}
      </span>
    `
  }

  // Apply a server update (update_chip_group() → receiveMessage() → here).
  // All state changes stay inside the component; a change event is
  // dispatched afterwards so the binding reports the (possibly new) value.
  receiveUpdate(msg: ChipGroupUpdate): void {
    // Choices apply before select so a combined update evaluates the new
    // selection against the new choices.
    if (msg.choices !== undefined) {
      this.choices = msg.choices
      // A checked value whose chip no longer exists necessarily falls out
      // of the checked set; the change event reports the new value.
      this.checked = this.checked.filter((value) => this.#isChoice(value))
    }

    if (msg.select !== undefined) {
      const select = Array.isArray(msg.select) ? msg.select : [msg.select]
      // update_chip_group() errors when it can see `values`; this guards
      // the values-unspecified path and hand-written JS.
      const known = select.filter((value) => this.#isChoice(value))

      if (known.length !== select.length) {
        console.warn(
          `bsides-chip-group: dropping value(s) not found in choices: ` +
            select.filter((value) => !this.#isChoice(value)).join(', ')
        )
      }

      // Replaces the checked set, in choices order (no merging).
      this.checked = this.choices
        .map((choice) => choice.value)
        .filter((value) => known.includes(value))
    }

    // Two one-way switches; when both arrive, disable wins.
    if (msg.enable === true) {
      this.disabled = false
    }

    if (msg.disable === true) {
      this.disabled = true
    }

    this.#dispatchChange()
  }

  #isChoice(value: string): boolean {
    return this.choices.some((choice) => choice.value === value)
  }

  #labelFor(value: string): string {
    return (
      this.choices.find((choice) => choice.value === value)?.label ?? value
    )
  }

  // A chip requested a checked-state toggle (click, Enter, or Space).
  #onChipToggle = (event: Event): void => {
    const { value } = (event as CustomEvent<{ value: string }>).detail
    const checked = new Set(this.checked)

    if (checked.has(value)) {
      checked.delete(value)
      this._announcement = `${this.#labelFor(value)} unchecked`
    } else {
      checked.add(value)
      this._announcement = `${this.#labelFor(value)} checked`
    }

    // Report checked in choices order.
    this.checked = this.choices
      .map((choice) => choice.value)
      .filter((choiceValue) => checked.has(choiceValue))
    this.#dispatchChange()
  }

  #dispatchChange(): void {
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
export type { ChipGroupUpdate }
