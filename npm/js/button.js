import $ from 'jquery'
import Input from './input.js'
import BoundInputs from './bound-inputs.js'

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

  content(text) {
    this._element.innerHTML = text

    return this
  }

  static initialize(element) {
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      input = new ButtonInput(element)
    }
  }

  static subscribe(element, callback) {
    $(element).on("click", (event) => {
      callback()
    })
  }
}

$(document).on(ButtonInput.EVENTS, ButtonInput.SELECTOR, (event) => {
  let button = BoundInputs.get(event.currentTarget, ButtonInput.BINDING_KEY)

  if (!button) {
    return
  }

  button.value(button.value() + 1)
})

if (Shiny) {
  Shiny.inputBindings.register(ButtonInput.ShinyInterface())
}

export default ButtonInput
