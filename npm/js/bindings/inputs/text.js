import $ from 'jquery'

import InputBinding from './input.js'

class TextInputBinding extends InputBinding {
  static get type() {
    return 'text'
  }

  get events() {
    return [
      'keyup',
      'input',
      'change'
    ]
  }

  get selectors() {
    return {
      value: 'input'
    }
  }

  getValue(element) {
    return element.value
  }

  getRatePolicy(element) {
    return {
      policy: 'debounce',
      delay: 250
    }
  }

  receiveMessage(element, data) {
    const $element = $(element)

    if (data.hasOwnProperty('value')) {
      $element.val(data.value)
    }

    if (data.hasOwnProperty('disable')) {
      $element.prop('disabled', data.disable)
    }

    $element.trigger('change')
  }
}

export default TextInputBinding