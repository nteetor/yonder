import $ from 'jquery'

import Input from './input.js'
import InputStore from '../utils/input-store.js'

class LinkInput extends Input {
  static get name() {
    return 'link'
  }

  static get events() {
    return `click.${this.namespace}`
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

  disable(x) {
    if (x === "true") {
      this.element.setAttribute("disabled", "")
    } else {
      this.element.removeAttribute("disabled")
    }
  }
}

$(document).on(LinkInput.events, LinkInput.selector, (event) => {
  let link = InputStore.get(event.currentTarget, LinkInput.type)

  if (!link) {
    return
  }

  event.preventDefault();

  link.value++
})

if (Shiny) {
  Shiny.inputBindings.register(LinkInput.ShinyInterface())
}

export default LinkInput
