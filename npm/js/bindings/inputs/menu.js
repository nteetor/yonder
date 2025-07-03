import $ from 'jquery'

import InputBinding from './input.js'

class MenuInputBinding extends InputBinding {
  static get type() {
    return 'menu'
  }

  get events() {
    return [
      { type: 'click', selector: this.selectors.choice }
    ]
  }

  get selectors() {
    return {
      choice: '.dropdown-item',
      value: '.dropdown-item'
    }
  }

  get data() {
    return {
      value: `${this.constructor.prefix}-value`
    }
  }

  initialize(element) {
    const $element = $(element)

    $element.on('click', this.selectors.value, (event) => {
      $element.data(this.data.value, event.currentTarget.value)
    })
  }

  getValue(element) {
    return $(element).data(this.data.value)
  }
}

export default MenuInputBinding