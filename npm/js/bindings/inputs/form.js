import $ from 'jquery'

import InputBinding from './input.js'

class FormInputBinding extends InputBinding {
  static get type() {
    return 'form'
  }

  get events() {
    return [
      { event: 'click', selector: this.selectors.submit }
    ]
  }

  get selectors() {
    return {
      submit: '.bsides-btn-submit'
    }
  }

  get data() {
    return {
      value: `${this.constructor.prefix}-value`
    }
  }

  initialize(element) {
    const $element = $(element)

    let inputValues = new Map()

    $element.on(`shiny:inputchanged${this.constructor.namespace}`, (event) => {
      if (!event.el || event.priority === 'event') {
        return
      }

      if (element.contains(event.el)) {
        const name = event.inputType ? `${event.name}:${event.inputType}` : event.name

        inputValues.set(name, event.value)
        event.preventDefault()
      }
    })

    $element.on(`click${this.constructor.namespace}`, this.selectors.submit, (event) => {
      event.preventDefault()

      for (const [key, value] of inputValues.entries()) {
        Shiny.setInputValue(key, value, { priority: 'event' })
      }

      const value = event.currentTarget.value

      $element.data(this.data.value, value)
    })
  }

  getValue(element) {
    return $(element).data(this.data.value)
  }

  receiveMessage(element, data) {
    const $element = $(element)

    if (data.hasOwnProperty('submit')) {
      console.log(data)

      const value = data.submit

      $element
        .find(`${this.selectors.submit}[value=${value}]`)
        .trigger('click')
    }
  }
}

export default FormInputBinding
