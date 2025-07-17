import $ from 'jquery'

import { addCustomMessageHandler, registerBinding } from '../../utils'
import InputBinding from './input.js'

class Chip {
  static create(text) {
    if (!text) {
      return
    }

    const chip = document.createElement('div')
    chip.classList.add('chip')
    chip.setAttribute('data-value', text)

    const closeButton = document.createElement('button')
    closeButton.setAttribute('type', 'button')
    closeButton.classList.add('btn-close')

    chip.innerText = text
    chip.appendChild(closeButton)

    return chip
  }

  static addEventListeners() {
    $(document).on('click.bsides.chip', '.chip .btn-close', (event) => {
      const button = event.currentTarget
      const $chip = $(button.parentElement)

      $chip.trigger('chip:remove.bsides.chip')
    })

    $(document).on('chip:remove.bsides.chip', '.chip', (event) => {
      event.currentTarget.remove()
    })
  }
}

class MultiSelectInput {
  #element
  #chipGroupElement
  #textInputElement

  static #instances = new WeakMap()

  get selectors() {
    return {

    }
  }

  constructor(element) {
    this.#element = element
    this.#textInputElement = element.querySelector('.multi-select-input')
    this.#chipGroupElement = element.querySelector('.chip-group')
    this.constructor.#instances.set(element, this)
  }

  value() {
    return Array.from(this.#chipGroupElement.children).map((chip) => {
      return chip.dataset.value
    })
  }

  text() {
    return this.#textInputElement.value
  }

  add() {
    const chip = Chip.create(this.text())
    this.#chipGroupElement.appendChild(chip)
    this.#textInputElement.value = ''
    $(this.#element).trigger('update.bsides.multiselect')
  }

  static addEventListeners() {
    const $document = $(document)

    $document.on('keyup.bsides.multiselect', '.multi-select', (event) => {
      if (event.key == 'Enter' || event.keyCode == 13) {
        const multiSelect = MultiSelectInput.getInstance(event.currentTarget)

        if (!multiSelect) {
          return
        }

        multiSelect.add()
      }
    })
  }

  static getInstance(element) {
    return this.#instances.get(element)
  }
}

class MultiSelectInputBinding extends InputBinding {
  static get type() {
    return 'multiselect'
  }

  get events() {
    return [
      'update',
      'chip:remove'
    ]
  }

  get selectors() {

  }

  getType(element) {
    // return `${this.constructor.prefix}${this.constructor.namespace}`
    return
  }

  getValue(element) {
    const multiSelect = MultiSelectInput.getInstance(element)

    if (!multiSelect) {
      return
    }

    return multiSelect.value()
  }

  initialize(element) {
    new MultiSelectInput(element)
  }

  receiveMessage(element, data) {

  }
}

Chip.addEventListeners()
MultiSelectInput.addEventListeners()

registerBinding(MultiSelectInputBinding)

export default MultiSelectInputBinding
