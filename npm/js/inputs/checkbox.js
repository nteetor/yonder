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

/*  choices(labels) {
    let $parent = $(this.element)
    let $choices =
      $parent
      .find(this.constructor.selectorChoice)
      .slice(0, labels.length)
      .map((i, el) => {
        el.innerHTML = labels[i]
        return el
      })
  }*/

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

    if (data.hasOwnProperty('choices')) {
      $element.find('.form-check').remove()
      $element.html(data['choices'])
    }

    $element.trigger('change')
  }
}

export default CheckboxInput
