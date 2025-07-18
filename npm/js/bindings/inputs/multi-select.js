import $ from 'jquery'

import { addCustomMessageHandler, registerBinding } from '../../utils'
import InputBinding from './input.js'

class Chip {
  #element
  #instances = new WeakMap()

  constructor(element) {
    this.#element = element
    this.#instances.set(element, this)
  }

  close() {
    const $element = $(this.#element)

    $element.trigger('close.bsides.chip')
    $element.fadeOut(200, () => this.#remove())
  }

  #remove() {
    this.#element.remove()
    $(this.#element).trigger('closed.bsides.chip')
    this.#instances.delete(this.#element)
  }

  static createElement(text) {
    if (!text) {
      return
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

  static getInstance(element) {
    return this.#instances.get(element)
  }

  static getOrCreateInstance(element) {
    const chip = this.getInstance(element)

    if (!chip) {
      return new this(element)
    }

    return chip
  }

  static addEventListeners() {
    $(document).on('click.bsides.chip', '[data-bs-dismiss="chip"]', (event) => {
      const chip = new Chip(event.currentTarget.parentElement)

      chip.close()
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
    return (this.#textInputElement.value || '').trim()
  }

  add() {
    const chip = Chip.createElement(this.text())
    new Chip(chip)
    this.#chipGroupElement.appendChild(chip)
    this.#textInputElement.value = ''
    $(this.#element).trigger('update.bsides.multiselect')
  }

  static getInstance(element) {
    return this.#instances.get(element)
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

    $document.on('close.bsides.chip', '.multi-select', (event) => {
      $(event.currentTarget).trigger('update.bsides.multiselect')
    })
  }
}

class MultiSelectInputBinding extends InputBinding {
  static get type() {
    return 'multiselect'
  }

  get events() {
    return [
      'update.bsides.multiselect'
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
