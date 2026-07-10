import $ from 'jquery'

import { InputBinding, registerBinding } from './_utils'

class Chip {
  #element: HTMLElement

  static #instances = new WeakMap<HTMLElement, Chip>()

  constructor(element: HTMLElement) {
    this.#element = element
    Chip.#instances.set(element, this)
  }

  close(): void {
    const $element = $(this.#element)

    $element.trigger('close.bsides.chip')
    $element.fadeOut(200, () => this.#remove())
  }

  #remove(): void {
    // Announce from the parent: the chip itself is detached after remove(),
    // so an event triggered on it could no longer bubble to listeners.
    const parent = this.#element.parentElement

    this.#element.remove()
    Chip.#instances.delete(this.#element)

    if (parent) {
      $(parent).trigger('closed.bsides.chip')
    }
  }

  static createElement(text: string): HTMLElement | undefined {
    if (!text) {
      return undefined
    }

    const chip = document.createElement('div')
    chip.classList.add('chip')
    chip.setAttribute('data-value', text)

    const closeButton = document.createElement('button')
    closeButton.setAttribute('type', 'button')
    closeButton.setAttribute('data-bs-dismiss', 'chip')
    closeButton.classList.add('btn-close')

    chip.innerText = text
    chip.appendChild(closeButton)

    return chip
  }

  static getInstance(element: HTMLElement): Chip | undefined {
    return Chip.#instances.get(element)
  }

  static getOrCreateInstance(element: HTMLElement): Chip {
    return this.getInstance(element) ?? new this(element)
  }

  static addEventListeners(): void {
    $(document).on('click.bsides.chip', '[data-bs-dismiss="chip"]', (event) => {
      const element = (event.currentTarget as HTMLElement).parentElement

      if (!element) {
        return
      }

      const chip = new Chip(element)

      chip.close()
    })
  }
}

class MultiSelectInput {
  #element: HTMLElement
  #chipGroupElement: HTMLElement
  #textInputElement: HTMLInputElement

  static #instances = new WeakMap<HTMLElement, MultiSelectInput>()

  constructor(element: HTMLElement) {
    this.#element = element
    this.#textInputElement = element.querySelector(
      '.multi-select-input'
    ) as HTMLInputElement
    this.#chipGroupElement = element.querySelector('.chip-group') as HTMLElement

    MultiSelectInput.#instances.set(element, this)
  }

  value(): Array<string | undefined> {
    return Array.from(this.#chipGroupElement.children).map((chip) => {
      return (chip as HTMLElement).dataset.value
    })
  }

  text(): string {
    return (this.#textInputElement.value || '').trim()
  }

  add(): void {
    const chip = Chip.createElement(this.text())

    if (!chip) {
      return
    }

    new Chip(chip)
    this.#chipGroupElement.appendChild(chip)
    this.#textInputElement.value = ''
    $(this.#element).trigger('update.bsides.multiselect')
  }

  static getInstance(element: HTMLElement): MultiSelectInput | undefined {
    return MultiSelectInput.#instances.get(element)
  }

  static addEventListeners(): void {
    const $document = $(document)

    $document.on('keyup.bsides.multiselect', '.multi-select', (event) => {
      if (event.key === 'Enter' || event.keyCode === 13) {
        const multiSelect = MultiSelectInput.getInstance(
          event.currentTarget as HTMLElement
        )

        if (!multiSelect) {
          return
        }

        multiSelect.add()
      }
    })

    // Update on 'closed' (after the chip is removed from the DOM), not
    // 'close' — otherwise the value reported to the server still includes
    // the closing chip.
    $document.on('closed.bsides.chip', '.multi-select', (event) => {
      $(event.currentTarget as HTMLElement).trigger('update.bsides.multiselect')
    })
  }
}

class MultiSelectInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-multi-select')
  }

  override initialize(el: HTMLElement): void {
    new MultiSelectInput(el)
  }

  override getValue(el: HTMLElement): Array<string | undefined> | undefined {
    const multiSelect = MultiSelectInput.getInstance(el)

    if (!multiSelect) {
      return undefined
    }

    return multiSelect.value()
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('update.bsides.multiselect', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('update.bsides.multiselect')
  }

  // update_multi_select() is still a stub on the R side; nothing to receive
  // yet.
  override receiveMessage(el: HTMLElement, data: unknown): void {
    void el
    void data
  }
}

Chip.addEventListeners()
MultiSelectInput.addEventListeners()

registerBinding(MultiSelectInputBinding, 'multiselect')

export { Chip, MultiSelectInput, MultiSelectInputBinding }
