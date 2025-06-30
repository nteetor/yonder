import $ from 'jquery'

import InputBinding from './input.js'

class LinkInputBinding extends InputBinding {
  static get type() {
    return 'link'
  }

  get events() {
    return ['click']
  }

  get data() {
    return {
      clicks: `${this.constructor.prefix}-clicks`
    }
  }

  initialize(element) {
    const $element = $(element)

    $element.data(this.data.clicks, 0)

    $element.on(`click${this.constructor.namespace}`, (event) => {
      const clicks = +$element.data(this.data.clicks)
      $element.data(this.data.clicks, clicks + 1)
    })
  }

  getType(element) {
    return `${this.constructor.prefix}${this.constructor.namespace}`
  }

  getValue(element) {
    return $(element).data(this.data.clicks)
  }
}

export default LinkInputBinding
