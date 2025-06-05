import $ from 'jquery'

import Input from './input.js'
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
      return ({ [element.value]: element.checked })
    })

    this.value = Object.assign(...entries)
  }

  setValue(key, x) {
    this.value[key] = x
    this.callback()

    return this
  }

  static getType(element) {
    return this.type
  }

}

$(document).on(CheckboxInput.events, CheckboxInput.selector, (event) => {
  let checkbox = InputStore.get(event.currentTarget, CheckboxInput.type)

  if (!checkbox) {
    return
  }

  let text = event.target.nextElementSibling.innerText
  let checked = event.target.checked

  checkbox.setValue(text, checked)

  console.log(checkbox.value)
})

if (Shiny) {
  Shiny.inputBindings.register(CheckboxInput.ShinyInterface())
}

export default CheckboxInput
