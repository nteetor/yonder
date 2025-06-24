import $ from 'jquery'

import Input from './input.js'
import ValuesMap from '../utils/values-map.js'
import InputStore from '../utils/input-store.js'

class CheckbuttonInput extends Input {
  static get name() {
    return 'checkbutton'
  }

  static get events() {
    return `change${this.namespace}`
  }

  constructor(element) {
    super(element)

    let entries = $(element).find('input').toArray().map((element) => {
      return [element.value, element.checked]
    })

    this.value = new ValuesMap(entries)
  }

  set callback(f) {
    this.value.callback = f
    super.callback = f
  }

  static getType(element) {
    return this.type
  }

  static getValue(element) {
    let checkbutton = InputStore.get(element, this.type)

    if (!checkbutton) {
      return null
    }

    return checkbutton.value.entries()
  }
}

$(document).on(CheckbuttonInput.events, CheckbuttonInput.selector, (event) => {
  let checkbutton = InputStore.get(event.currentTarget, CheckbuttonInput.type)

  if (!checkbutton) {
    return
  }

  let text = event.target.nextElementSibling.innerText
  let checked = event.target.checked

  checkbutton.value.set(text, checked)
})

if (Shiny) {
  Shiny.inputBindings.register(CheckbuttonInput.ShinyInterface())
}

export default CheckbuttonInput
