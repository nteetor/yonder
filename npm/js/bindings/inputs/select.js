import $ from 'jquery'

import InputBinding from './input.js'

class SelectInputBinding extends InputBinding {
  static get type() {
    return 'select'
  }

  get events() {
    return ['change']
  }

  get selectors() {
    return {
      value: 'option'
    }
  }

  getValue(element) {
    return element.value;
  }

  receiveMessage(element, data) {
    const $element = $(element)

    console.log(data)

    if (data.hasOwnProperty('options')) {
      $element.find(this.selectors.value).remove()
      $element.html(data.options)
    }

    if (data.hasOwnProperty('select')) {
      $element.val(data.select)
    }

    if (data.hasOwnProperty('disable')) {
      console.log('disable')
      const $values = $element.find('option')
      $values.prop('disabled', false)

      $values
        .filter((i, e) => data.disable.includes(e.value))
        .prop('disabled', true)
    }

    $element.trigger('change')
  }
}

export default SelectInputBinding