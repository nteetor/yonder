import $ from 'jquery'

import InputStore from '../utils/input-store.js'
import Input from './input.js'

class ButtonInput extends Input {
  static get name() {
    return 'button'
  }

  static get events() {
    return `click${this.namespace}`
  }

  constructor(element) {
    super(element)

    this.value = 0
  }

  set label(x) {
    this.element.innerHTML = x
  }

  get label() {
    this.element.innerHTML
  }

  // this argument name is garbo
  disable(x) {
    if (x === true) {
      this.element.setAttribute('disabled', '')
    } else {
      this.element.removeAttribute('disabled')
    }

    return this
  }
}

$(document).on(ButtonInput.events, ButtonInput.selector, (event) => {
  let button = InputStore.get(event.currentTarget, ButtonInput.type)

  if (!button) {
    return
  }

  button.value++
})

if (Shiny) {
  Shiny.inputBindings.register(ButtonInput.ShinyInterface())
}

export default ButtonInput
