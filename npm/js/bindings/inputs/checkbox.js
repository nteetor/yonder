import $ from 'jquery'

import InputBinding from './input.js'

class CheckboxInputBinding extends InputBinding {
  static get type() {
    return 'checkbox'
  }

  get events() {
    return ['change']
  }

  get selectors() {
    return {
      label: '.form-check-label',
      value: '.form-check-input'
    }
  }

  getValue(element) {
    return $(element).children(this.selectors.value).prop('checked')
  }
}

export default CheckboxInputBinding