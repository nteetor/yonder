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
    const $label = $element.find(this.selectors.label)
    const $value = $element.find(this.selectors.value)

    if (data.hasOwnProperty('choice')) {
      $label.html(data.choice)
    }

    if (data.hasOwnProperty('value')) {
      $value.prop('checked', data.value)
    }

    if (data.hasOwnProperty('disable')) {
      $value.prop('disabled', data.disable)
    }

    $element.trigger('change')
  }
}

export default CheckboxInputBinding