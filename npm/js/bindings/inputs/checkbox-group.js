import $ from 'jquery'

import InputBinding from './input.js'

class CheckboxGroupInputBinding extends InputBinding {
  static get type() {
    return 'checkboxgroup'
  }

  get events() {
    return ['change']
  }

  get selectors() {
    return {
      choice: '.form-check-label,.btn',
      value: '.form-check-input,.btn-check'
    }
  }

  getType(element) {
    return `${this.constructor.prefix}${this.constructor.namespace}`
  }

  getValue(element) {
    const values =
      $(element)
      .find(this.selectors.value)
      .filter(':checked')
      .map((i, el) => el.value)
      .get()

    console.log(values)

    return values
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

export default CheckboxGroupInputBinding
