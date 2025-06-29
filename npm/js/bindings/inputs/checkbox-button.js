import $ from 'jquery'

import InputBinding from './input.js'

class CheckboxButtonInputBinding extends InputBinding {
  static get type() {
    return 'checkboxbutton'
  }

  get events() {
    return ['change']
  }

  get selectors() {
    return {
      choice: '.btn',
      value: '.btn-check'
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

export default CheckboxButtonInputBinding
