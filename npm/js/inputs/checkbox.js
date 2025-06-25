import $ from 'jquery'

import Input from './input.js'
import ValuesMap from '../utils/values-map.js'
import InputStore from '../utils/input-store.js'

class CheckboxInput extends Input {
  static get name() {
    return 'checkbox'
  }

  static get events() {
    return ['change']
  }

  static get selectors() {
    return {
      choice: '.form-check-label',
      value: '.form-check-input'
    }
  }

  static getType(element) {
    return this.type
  }

  static getValue(element) {
    let pairs =
      $(element)
      .find(this.selectors.value)
      .map((i, e) => [[e.value, e.checked]])
      .get()

    return Object.fromEntries(pairs)
  }

  static receiveMessage(element, data) {
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

export default CheckboxInput
