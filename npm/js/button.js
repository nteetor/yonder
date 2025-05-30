import $ from 'jquery'

import InputStore from './input-store.js'
import Input from './input.js'

class ButtonInput extends Input {
  static get NAME() {
    return 'button'
  }

  static get EVENTS() {
    return `click${this.EVENT_KEY}`
  }

  constructor(element) {
    super(element)

    this._value = 0
  }

  value(x) {
    if (typeof x === 'undefined') {
      return this._value
    }

    this._value = x
    this._callback(this._debounce)

    return this
  }

  content(x) {
    this._element.innerHTML = x

    return this
  }

  // this argument name is garbo
  disable(x) {
    if (x === true) {
      this._element.setAttribute('disabled', '')
    } else {
      this._element.removeAttribute('disabled')
    }

    return this
  }

  static initialize(element) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      input = new ButtonInput(element)
    }
  }
}

$(document).on(ButtonInput.EVENTS, ButtonInput.SELECTOR, (event) => {
  let button = InputStore.get(event.currentTarget, ButtonInput.BINDING_KEY)

  if (!button) {
    return
  }

  button.value(button.value() + 1)
})

if (Shiny) {
  Shiny.inputBindings.register(ButtonInput.ShinyInterface())
}

export default ButtonInput
