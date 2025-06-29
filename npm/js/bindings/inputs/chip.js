import $ from 'jquery'
import Dropdown from 'bootstrap'

import InputStore from '../utils/input-store.js'

class ChipInput extends Input {
  static get name() {
    return 'chip'
  }

  static get events() {
    return [
      { click: `${this.choice.dropdown},${this.choice.chip}` }
    ]
  }

  static get selectors() {
    return {
      choice: {
        dropdown: '.dropdown-item',
        chip: '.chip'
      },
      value: {

      }
    }
  }

  static getType(element) {
    return this.type
  }

  static getValue(element) {


  }

  static receiveMessage(element, data) {

  }

}

export default ChipInput