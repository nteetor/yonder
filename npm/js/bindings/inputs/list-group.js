import $ from 'jquery'

import InputBinding from './input.js'

class ListGroupInputBinding extends InputBinding {
  static get type() {
    return 'listgroup'
  }

  get events() {
    return ['click']
  }

  get selectors() {
    return {
      choice: '.list-group-item-action',
      value: '.list-group-item-action'
    }
  }

  get data() {
    return {
      value: `${this.constructor.prefix}-value`
    }
  }

  initialize(element) {
    const $element = $(element)

    $element.on('click', this.selectors.choice, (event) => {
      const $choice = $(event.currentTarget)

      $choice.toggleClass('active')
    })
  }

  getValue(element) {
    return $(element)
      .find(`${this.selectors.value}.active`)
      .map((i, el) => el.getAttribute(`data-${this.data.value}`))
      .get()
  }
}

export default ListGroupInputBinding