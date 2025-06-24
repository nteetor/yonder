import $ from 'jquery'

import InputStore from '../utils/input-store.js'

class ChipInput extends Input {
  static get name() {
    return 'chip'
  }

  static get events() {
    return `click${this.namespace}`
  }

  constructor(element) {
    super(element)

    this.value = null
  }

  toggleDropdown() {

  }
}

$(document).on('input', '.bsides-chip input', (event) => {
  let chip = InputStore.get(event.target, ChipInput.type)

  if (!chip) {
    return
  }

  chip.toggleDropdown()
})


if (Shiny) {
  Shiny.inputBindings.register(ChipInput.ShinyInterface())
}

export default ChipInput