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
      choice: '.form-check-label',
      value: '.form-check-input'
    }
  }

  getType(element) {
    console.log(this.constructor)
    return `${this.constructor.prefix}${this.constructor.namespace}`
  }

  getValue(element) {
    let pairs =
      $(element)
      .find(this.selectors.value)
      .map((i, e) => [[e.value, e.checked]])
      .get()

    return Object.fromEntries(pairs)
  }

  receiveMessage(element, data) {
    const $element = $(element)
    const $values = $element.find(this.selectors.value)

    if (data.hasOwnProperty('options')) {
      $element.find('.form-check').remove()
      $element.html(data.options)
    }

    if (data.hasOwnProperty('select')) {
      $values.prop('checked', false)

      $values
        .filter((i, e) => data.select.includes(e.value))
        .prop('checked', true)
    }

    if (data.hasOwnProperty('disable')) {
      $values.prop('disabled', false)

      $values
        .filter((i, e) => data.disable.includes(e.value))
        .prop('disabled', true)
    }

    $element.trigger('change')
  }
}

export default CheckboxInputBinding
