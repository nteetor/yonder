import $ from 'jquery'

import InputBinding from './input.js'

class RangeInputBinding extends InputBinding {
  static get type() {
    return 'range'
  }

  get events() {
    return ['change']
  }

  get selectors() {
    return {
      value: '.form-range'
    }
  }

  getValue(element) {
    return +$(element).find(this.selectors.value).val()
  }

  receiveMessage(element, data) {
    const $element = $(element)
    const $value = $element.find(this.selectors.value)

    if (data.hasOwnProperty('value')) {
      $value.val(data.value)
    }

    if (data.hasOwnProperty('disable')) {
      $value.prop('disable', data.disable)
    }

    $element.trigger('change')
  }
}

export default RangeInputBinding