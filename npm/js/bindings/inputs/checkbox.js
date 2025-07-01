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

  receiveMessage(element, data) {
    const $element = $(element)

    if (data.hasOwnProperty('choice')) {
      $element.find(this.selectors.label).html(data.choice)
    }

    if (data.hasOwnProperty('value')) {
      console.log(data.value)
      $element.find(this.selectors.value).prop('checked', data.value)
    }

    if (data.hasOwnProperty('disable')) {
      $element.find(this.selectors.value).prop('disabled', data.disable)
    }
  }
}

export default CheckboxInputBinding