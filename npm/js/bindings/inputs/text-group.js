import $ from 'jquery'

import InputBinding from './input.js'

class TextGroupInputBinding extends InputBinding {
  static get type() {
    return 'textgroup'
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
      value: 'input',
      text: '.input-group-text'
    }
  }

  getValue(element) {
    const $element = $(element)

    if (!$element.find(this.selectors.value).val()) {
      return null
    }

    return $element
      .find(`${this.selectors.text},${this.selectors.value}`)
      .map((i, e) => e.innerText || e.value || '')
      .get()
      .join('')
  }

  getRatePolicy(element) {
    return {
      policy: 'debounce',
      delay: 250
    }
  }

  receiveMessage(element, data) {
    const $element = $(element)
    const $value = $(element).find(this.selectors.value)

    if (data.hasOwnProperty('value')) {
      $value.val(data.value)
    }

    if (data.hasOwnProperty('disable')) {
      $value.prop('disabled', data.disable)
    }

    $element.trigger('change')
  }
}

export default TextGroupInputBinding