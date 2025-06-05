import $ from 'jquery'

import Input from './input.js'
import ValuesMap from '../utils/values-map.js'
import InputStore from '../utils/input-store.js'

class CheckboxInput extends Input {
  static get name() {
    return 'checkbox'
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
    let checkbox = InputStore.get(element, this.type)

    if (!checkbox) {
      return null
    }

    return checkbox.value.entries()
  }
}

$(document).on(CheckboxInput.events, CheckboxInput.selector, (event) => {
  let checkbox = InputStore.get(event.currentTarget, CheckboxInput.type)

  if (!checkbox) {
    return
  }

  let text = event.target.nextElementSibling.innerText
  let checked = event.target.checked

  checkbox.value.set(text, checked)

  console.log(checkbox.value.toObject())
})

if (Shiny) {
  Shiny.inputBindings.register(CheckboxInput.ShinyInterface())
}

export default CheckboxInput
