import $ from 'jquery'

import { registerBinding } from '../../utils'
import InputBinding from './input'
import type { BindingEvent } from './input'

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
    this.#element.remove()
    $(this.#element).trigger('closed.bsides.chip')
    Chip.#instances.delete(this.#element)
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

    $document.on('close.bsides.chip', '.multi-select', (event) => {
      $(event.currentTarget as HTMLElement).trigger('update.bsides.multiselect')
    })
  }
}

class MultiSelectInputBinding extends InputBinding {
  static override get type(): string {
    return 'multiselect'
  }

  override get events(): BindingEvent[] {
    return [
      'update.bsides.multiselect'
    ]
  }

  override getType(element: HTMLElement): string | null {
    void element
    return null
  }

  override getValue(element: HTMLElement): Array<string | undefined> | undefined {
    const multiSelect = MultiSelectInput.getInstance(element)

    if (!multiSelect) {
      return undefined
    }

    return multiSelect.value()
  }

  override initialize(element: HTMLElement): void {
    new MultiSelectInput(element)
  }

  override receiveMessage(element: HTMLElement, data: unknown): void {
    void element
    void data
  }
}

Chip.addEventListeners()
MultiSelectInput.addEventListeners()

registerBinding(MultiSelectInputBinding)

export default MultiSelectInputBinding
export { Chip, MultiSelectInput }
