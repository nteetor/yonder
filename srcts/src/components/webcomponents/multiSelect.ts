import { LitElement, html, nothing } from 'lit'
import { ifDefined } from 'lit/directives/if-defined.js'
import { repeat } from 'lit/directives/repeat.js'

import './chip'
import type { ChipData } from './chip'

// The Popover API promotes the menu to the top layer, whose containing
// block is the viewport — escaping ancestor overflow clipping (bslib puts
// overflow: auto on cards and card bodies) and containing-block traps
// (e.g. a transformed .modal-dialog). Without it the menu keeps the
// absolute fallback positioning in _multi-select.scss and clips as before.
const supportsPopover =
  typeof HTMLElement.prototype.showPopover === 'function'

// The menu's default max-height (15rem at the 16px default root font
// size) and its gutters: the spacer below the field (.125rem) and the
// breathing room kept from the viewport's bottom edge.
const menuMaxHeight = 240
const menuSpacer = 2
const menuViewportGutter = 8

// Message shape sent by update_multi_select() on the R side. `select`
// replaces the chip set (shiny's convention — no merging) and may arrive
// as a bare string: Shiny serializes length-1 vectors as scalars.
// `enable`/`disable` are whole-input switches.
interface MultiSelectUpdate {
  choices?: ChipData[]
  select?: string | string[]
  placeholder?: string
  max?: number
  enable?: boolean
  disable?: boolean
}

// The multi select input element: selected values render as removable
// chips (they do not toggle — the chip set IS the value), edited through a
// text entry + filtering combobox. The dropdown lists all choices with a
// checkmark beside current members; selecting a member removes it,
// selecting a non-member adds it.
//
// `edit` bounds what the set may contain:
// - "choices" (default): members come only from `choices`.
// - "free": typed text may create chips not among the choices; without
//   `choices` there is no dropdown at all (pure tag entry).
class BsidesMultiSelect extends LitElement {
  static override properties = {
    chips: { type: Array },
    choices: { type: Array },
    edit: { type: String, reflect: true },
    type: { type: String },
    layout: { type: String, reflect: true },
    max: { type: Number },
    placeholder: { type: String },
    disabled: { type: Boolean, reflect: true },
    label: { type: String },
    _announcement: { state: true },
    _open: { state: true },
    _query: { state: true },
    _activeIndex: { state: true }
  }

  declare chips: string[]
  declare choices: ChipData[]
  declare edit: 'choices' | 'free'
  declare type: string
  declare layout: 'vertical' | 'horizontal'
  declare max: number | null
  declare placeholder: string
  declare disabled: boolean
  declare label: string
  declare _announcement: string
  declare _open: boolean
  declare _query: string
  declare _activeIndex: number

  // Fallback for aria-controls/aria-activedescendant ids when the element
  // itself has no id.
  #uid = `bsides-multi-select-${Math.random().toString(36).slice(2, 8)}`

  // Whether the menu is currently shown as a top-layer popover. Tracked
  // here rather than via :popover-open so show/hide stay balanced even
  // when a close lands before the open's render round trip completes.
  #popoverShown = false

  constructor() {
    super()
    this.chips = []
    this.choices = []
    this.edit = 'choices'
    this.type = 'primary'
    this.layout = 'vertical'
    this.max = null
    this.placeholder = ''
    this.disabled = false
    this.label = ''
    this._announcement = ''
    this._open = false
    this._query = ''
    this._activeIndex = -1

    this.addEventListener('bsides-chip:remove', this.#onChipRemove)
  }

  override createRenderRoot(): this {
    return this
  }

  override disconnectedCallback(): void {
    super.disconnectedCallback()
    document.removeEventListener('pointerdown', this.#onOutsidePointerdown)
    this.#removeViewportListeners()
    // Removal from the DOM force-hides an open popover; resync.
    this.#popoverShown = false
  }

  // Re-anchor an open top-layer menu after any re-render: chip changes
  // resize the field, which moves the menu's anchor point.
  override updated(): void {
    if (this.#popoverShown) {
      this.#positionMenu()
    }
  }

  override render(): unknown {
    return html`
      <div class="multi-select-field" @mousedown=${this.#onFieldMousedown}>
        <div class="multi-select-field-content">
          <div
            class="multi-select-chips"
            role="group"
            aria-label=${this.label || 'Selected values'}
          >
            ${repeat(
              this.chips,
              (value) => value,
              (value) => {
                const chip = this.#chipFor(value)

                return html`<bsides-chip
                  .value=${chip.value}
                  .label=${chip.label}
                  .type=${this.type}
                  removable
                  ?disabled=${this.disabled}
                ></bsides-chip>`
              }
            )}
          </div>
          <input
            type="text"
            class="multi-select-input"
            placeholder=${ifDefined(
              this.chips.length === 0 ? this.placeholder || undefined : undefined
            )}
            ?disabled=${this.disabled || this.#atMax()}
            data-shiny-no-bind-input
            role=${ifDefined(this.#comboboxAttr('combobox'))}
            aria-expanded=${ifDefined(this.#comboboxAttr(String(this._open)))}
            aria-controls=${ifDefined(this.#comboboxAttr(this.#menuId()))}
            aria-autocomplete=${ifDefined(this.#comboboxAttr('list'))}
            aria-activedescendant=${ifDefined(this.#activeOptionId())}
            @keydown=${this.#onKeydown}
            @input=${this.#onInput}
            @focus=${this.#onFocus}
            @blur=${this.#onBlur}
          />
        </div>
        ${this.#renderCaret()}
      </div>
      ${this.#renderMenu()}
      <span class="visually-hidden" aria-live="polite">
        ${this._announcement}
      </span>
    `
  }

  // The dropdown indicator at the field's trailing edge. Decorative: its
  // clicks fall through to the field (pointer-events: none), which opens
  // the menu — open-only, never a toggle. Rendered outside
  // .multi-select-field-content so horizontal scrolling passes under it.
  #renderCaret(): unknown {
    if (!this.#hasMenu()) {
      return nothing
    }

    return html`<svg
      class="multi-select-caret${this._open ? ' open' : ''}"
      viewBox="0 0 16 16"
      width="1em"
      height="1em"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      aria-hidden="true"
    >
      <path d="M4 6 8 10 12 6" />
    </svg>`
  }

  // The filtering listbox: all choices, a checkmark beside current
  // members, selection toggles membership. Bootstrap's
  // .dropdown-menu/.dropdown-item CSS classes only — the dropdown plugin's
  // menu-button focus model doesn't fit a combobox, so visibility and
  // selection are handled here (see plan-multi-select-input.md).
  #renderMenu(): unknown {
    if (!this.#hasMenu()) {
      return nothing
    }

    const options = this.#filteredChoices()

    return html`
      <ul
        id=${this.#menuId()}
        class="dropdown-menu${this._open ? ' show' : ''}"
        popover=${ifDefined(supportsPopover ? 'manual' : undefined)}
        role="listbox"
        aria-label="Options"
        @mousedown=${this.#onMenuMousedown}
      >
        ${options.length === 0
          ? html`<li><span class="dropdown-item disabled">No matches</span></li>`
          : options.map((choice, index) => {
              const member = this.chips.includes(choice.value)

              return html`
                <li role="presentation">
                  <button
                    type="button"
                    id=${this.#optionId(index)}
                    class="dropdown-item${index === this._activeIndex
                      ? ' active'
                      : ''}"
                    role="option"
                    aria-selected=${member ? 'true' : 'false'}
                    @click=${() => this.#toggleChoice(choice)}
                  >
                    ${member
                      ? html`<svg
                          class="option-check"
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
                      : nothing}
                    ${choice.label}
                  </button>
                </li>
              `
            })}
      </ul>
    `
  }

  // Apply a server update (update_multi_select() → receiveMessage() →
  // here). All state changes stay inside the component; a change event is
  // dispatched afterwards so the binding reports the (possibly new) value.
  receiveUpdate(msg: MultiSelectUpdate): void {
    // Choices apply before select so a combined update evaluates the new
    // selection against the new choices.
    if (msg.choices !== undefined) {
      this.choices = msg.choices

      // Members no longer among the choices are pruned — except at
      // edit = "free", where off-choices members are legitimate
      // (free-created chips).
      if (this.edit !== 'free') {
        this.chips = this.chips.filter((value) => this.#isChoice(value))
      }
    }

    if (msg.select !== undefined) {
      const select = Array.isArray(msg.select) ? msg.select : [msg.select]
      // Bounded mode: members come only from the choices.
      // update_multi_select() errors when it can see `values`; this guards
      // the values-unspecified path and hand-written JS.
      const known =
        this.edit === 'free'
          ? select
          : select.filter((value) => this.#isChoice(value))

      if (known.length !== select.length) {
        console.warn(
          `bsides-multi-select: dropping value(s) not found in choices: ` +
            select.filter((value) => !this.#isChoice(value)).join(', ')
        )
      }

      // Replaces the chip set (no merging).
      this.chips = known
    }

    if (msg.placeholder !== undefined) {
      this.placeholder = msg.placeholder
    }

    if (msg.max !== undefined) {
      this.max = msg.max
    }

    // Two one-way switches; when both arrive, disable wins.
    if (msg.enable === true) {
      this.disabled = false
    }

    if (msg.disable === true) {
      this.disabled = true
      this.#closeMenu()
    }

    this.#dispatchChange()
  }

  // There is a dropdown whenever the set is bounded by choices, or
  // choices exist to suggest at edit = "free" (the mixed mode). A free
  // input without choices is pure tag entry.
  #hasMenu(): boolean {
    return this.edit === 'choices' || this.choices.length > 0
  }

  #atMax(): boolean {
    return this.max != null && this.chips.length >= this.max
  }

  #isChoice(value: string): boolean {
    return this.choices.some((choice) => choice.value === value)
  }

  // The chip for a member value: its choice's label when one exists,
  // otherwise the value labels itself (free-created chips).
  #chipFor(value: string): ChipData {
    const choice = this.choices.find((choice) => choice.value === value)

    return choice ?? { label: value, value }
  }

  // All choices matching the typed text, case-insensitively, by label —
  // members included (they show a checkmark and toggle off).
  #filteredChoices(): ChipData[] {
    const query = this._query.trim().toLowerCase()

    return this.choices.filter((choice) =>
      choice.label.toLowerCase().includes(query)
    )
  }

  get #inputElement(): HTMLInputElement | null {
    return this.querySelector('.multi-select-input')
  }

  #comboboxAttr(value: string): string | undefined {
    return this.#hasMenu() ? value : undefined
  }

  #menuId(): string {
    return `${this.id || this.#uid}-listbox`
  }

  #optionId(index: number): string {
    return `${this.#menuId()}-option-${index}`
  }

  #activeOptionId(): string | undefined {
    return this._open && this._activeIndex >= 0
      ? this.#optionId(this._activeIndex)
      : undefined
  }

  #openMenu(): void {
    if (this._open || !this.#hasMenu() || this.disabled || this.#atMax()) {
      return
    }

    this._open = true
    document.addEventListener('pointerdown', this.#onOutsidePointerdown)

    if (supportsPopover) {
      window.addEventListener('resize', this.#onViewportChange)
      // Capture catches scrolling containers between here and the
      // document (a bslib card body scrolls, not just the page).
      document.addEventListener('scroll', this.#onViewportChange, {
        capture: true,
        passive: true
      })

      // The top-layer promotion waits for the render pass that displays
      // the menu (.show); a close arriving first simply skips it.
      void this.updateComplete.then(() => {
        if (this._open) {
          this.#showMenuPopover()
        }
      })
    }
  }

  #closeMenu(): void {
    if (!this._open) {
      return
    }

    this._open = false
    this._activeIndex = -1
    document.removeEventListener('pointerdown', this.#onOutsidePointerdown)
    this.#removeViewportListeners()
    this.#hideMenuPopover()
  }

  #removeViewportListeners(): void {
    window.removeEventListener('resize', this.#onViewportChange)
    document.removeEventListener('scroll', this.#onViewportChange, {
      capture: true
    })
  }

  #onViewportChange = (): void => {
    this.#positionMenu()
  }

  #showMenuPopover(): void {
    const menu = this.#menuElement

    if (!supportsPopover || !menu || this.#popoverShown) {
      return
    }

    menu.showPopover()
    this.#popoverShown = true
    this.#positionMenu()
  }

  #hideMenuPopover(): void {
    const menu = this.#menuElement

    if (!supportsPopover || !menu || !this.#popoverShown) {
      return
    }

    menu.hidePopover()
    this.#popoverShown = false
  }

  // Anchor the top-layer menu to the field in viewport coordinates: below
  // the field, spanning its width, capped to the space above the
  // viewport's bottom edge so a low menu scrolls internally rather than
  // running off screen. (The absolute fallback positions in CSS instead.)
  #positionMenu(): void {
    const menu = this.#menuElement
    const field = this.querySelector('.multi-select-field')

    if (!menu || !field) {
      return
    }

    const rect = field.getBoundingClientRect()
    const top = rect.bottom + menuSpacer

    menu.style.left = `${rect.left}px`
    menu.style.top = `${top}px`
    menu.style.width = `${rect.width}px`
    menu.style.maxHeight = `${Math.max(
      0,
      Math.min(menuMaxHeight, window.innerHeight - top - menuViewportGutter)
    )}px`
  }

  get #menuElement(): HTMLElement | null {
    return this.querySelector('.dropdown-menu')
  }

  #onOutsidePointerdown = (event: Event): void => {
    if (!this.contains(event.target as Node)) {
      this.#closeMenu()
    }
  }

  // Pressing on the menu must not steal focus from the text input —
  // otherwise the input blurs before the option's click event lands.
  #onMenuMousedown = (event: Event): void => {
    event.preventDefault()
  }

  // Clicking anywhere in the field — its padding or the caret — focuses
  // the text input and opens the menu. Clicks on the input itself or
  // inside a chip keep their native behavior (caret placement, removal).
  // preventDefault stops the press from blurring an already-focused input,
  // which would flicker the menu closed and back open.
  #onFieldMousedown = (event: Event): void => {
    const target = event.target as HTMLElement

    if (
      this.disabled ||
      target.closest('.multi-select-input, bsides-chip') !== null
    ) {
      return
    }

    event.preventDefault()
    this.#inputElement?.focus()
    // Focusing opens the menu via #onFocus, but not when the input was
    // already focused (say, closed with Escape) — open explicitly.
    this.#openMenu()
  }

  #onFocus = (): void => {
    this.#openMenu()
  }

  #onBlur = (): void => {
    this.#closeMenu()
  }

  #onInput = (event: Event): void => {
    this._query = (event.target as HTMLInputElement).value
    this.#openMenu()
    // Typing re-filters; the first match becomes active and the menu
    // scrolls back up to it (it may have been scrolled from before).
    this._activeIndex = this.#filteredChoices().length > 0 ? 0 : -1
    this.#scrollActiveIntoView()
  }

  #onKeydown = (event: KeyboardEvent): void => {
    const input = event.target as HTMLInputElement

    if (event.key === 'Backspace' && input.value === '') {
      this.#removeLast()
      return
    }

    // Pure tag entry (edit = "free", no choices): Enter turns the typed
    // text into a chip.
    if (!this.#hasMenu()) {
      if (event.key === 'Enter') {
        event.preventDefault()
        this.#createFree(input.value)
      }

      return
    }

    // The combobox keyboard pattern. Focus never leaves the text input;
    // arrows move the active option instead.
    const options = this.#filteredChoices()

    switch (event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.#openMenu()
        this.#moveActive(1, options.length)
        this.#scrollActiveIntoView()
        break
      case 'ArrowUp':
        event.preventDefault()
        this.#openMenu()
        this.#moveActive(-1, options.length)
        this.#scrollActiveIntoView()
        break
      case 'Enter': {
        // The active option or, when nothing is active, a unique
        // exact-label match — either way membership toggles. At
        // edit = "free" unmatched text creates a chip; otherwise free
        // text is never added.
        event.preventDefault()

        const choice =
          this._activeIndex >= 0 && this._activeIndex < options.length
            ? options[this._activeIndex]
            : this.#exactMatch(options, input.value)

        if (choice) {
          this.#toggleChoice(choice)
        } else if (this.edit === 'free') {
          this.#createFree(input.value)
        }

        break
      }
      case 'Escape':
        // First Escape closes the menu but keeps the typed text; a second
        // clears the text.
        if (this._open) {
          this.#closeMenu()
        } else {
          this.#clearQuery()
        }

        break
      case 'Tab':
        this.#closeMenu()
        break
    }
  }

  // Keep the active option visible. The combobox pattern focuses the
  // text input, never the option — the active option is only virtually
  // focused, and browsers auto-scroll only the truly focused element.
  // Scoped scrollTop math rather than scrollIntoView so only the menu
  // ever scrolls (never the page or a containing card); the options'
  // offsetParent is the menu on both positioning paths.
  #scrollActiveIntoView(): void {
    void this.updateComplete.then(() => {
      const menu = this.#menuElement
      const option = menu?.querySelector<HTMLElement>('.dropdown-item.active')

      if (!menu || !option) {
        return
      }

      // Padding-aware bounds so the menu's own padding is revealed at
      // the list's ends (a bare offsetTop would stop 8px short of the
      // top, leaving the first option flush against the cut edge).
      const styles = getComputedStyle(menu)
      const top =
        option.offsetTop - (parseFloat(styles.paddingTop) || 0)
      const bottom =
        option.offsetTop +
        option.offsetHeight +
        (parseFloat(styles.paddingBottom) || 0)

      if (top < menu.scrollTop) {
        menu.scrollTop = top
      } else if (bottom > menu.scrollTop + menu.clientHeight) {
        menu.scrollTop = bottom - menu.clientHeight
      }
    })
  }

  // Move the active option by delta, wrapping at the ends; entering the
  // list lands on the first (down) or last (up) option.
  #moveActive(delta: number, count: number): void {
    if (count === 0) {
      this._activeIndex = -1
      return
    }

    this._activeIndex =
      this._activeIndex < 0
        ? delta > 0
          ? 0
          : count - 1
        : (this._activeIndex + delta + count) % count
  }

  #exactMatch(options: ChipData[], text: string): ChipData | undefined {
    const query = text.trim().toLowerCase()

    if (!query) {
      return undefined
    }

    const matches = options.filter(
      (choice) => choice.label.toLowerCase() === query
    )

    return matches.length === 1 ? matches[0] : undefined
  }

  // Selecting a listed choice toggles its membership: members are
  // removed, non-members added (dropdown click or Enter).
  #toggleChoice(choice: ChipData): void {
    if (this.chips.includes(choice.value)) {
      this.#removeMember(choice.value)
      return
    }

    this.#addMember(choice)
  }

  #addMember(choice: ChipData): void {
    if (this.#atMax() || this.chips.includes(choice.value)) {
      return
    }

    this.chips = [...this.chips, choice.value]
    this.#clearQuery()
    this._activeIndex = -1
    this._announcement = `${choice.label} added`
    this.#dispatchChange()

    // The menu stays open for further picks unless the limit was reached
    // (the input is disabled at max, so the menu must not linger).
    if (this.#atMax()) {
      this.#closeMenu()
    }
  }

  // Create a chip from typed text (edit = "free"). Duplicates are
  // rejected; the typed text stays so the collision is visible.
  #createFree(text: string): void {
    const value = text.trim()

    if (!value || this.#atMax() || this.chips.includes(value)) {
      return
    }

    this.#addMember({ label: value, value })
  }

  #removeLast(): void {
    if (this.chips.length === 0) {
      return
    }

    this.#removeMember(this.chips[this.chips.length - 1])
  }

  #removeMember(value: string): void {
    this.chips = this.chips.filter((chip) => chip !== value)
    this._announcement = `${this.#chipFor(value).label} removed`
    this.#dispatchChange()
  }

  #clearQuery(): void {
    const input = this.#inputElement

    if (input) {
      input.value = ''
    }

    this._query = ''
  }

  // A chip's close button requested removal.
  #onChipRemove = (event: Event): void => {
    const { value } = (event as CustomEvent<{ value: string }>).detail

    this.#removeMember(value)

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
export type { MultiSelectUpdate }
