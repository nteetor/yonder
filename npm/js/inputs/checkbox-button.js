import $ from 'jquery'

import Input from './input.js'

class CheckboxButtonInput extends Input {
  static get name() {
    return 'checkbox-button'
  }

  static get events() {
    return ['change']
  }

  static get selectors() {
    return {
      choice: '.btn',
      value: '.btn-check'
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
      $element
        .find(`${this.selectors.choice},${this.selectors.value}`)
        .remove()

      $element.html(data.options)
    }

    if (data.hasOwnProperty('select')) {
      $values.prop('checked', false)

      console.log($values)
      console.log($values.filter((i, e) => data.select.includes(e.value)))

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

export default CheckboxButtonInput
