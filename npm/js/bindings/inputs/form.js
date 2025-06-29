import $ from 'jquery'

import InputBinding from './input.js'

class FormInputBinding extends InputBinding {
  static get type() {
    return 'form'
  }

  get events() {
    return ['submit']
  }

  get selectors() {
    return {
      submit: '.bsides-btn-submit'
    }
  }

  initialize(element) {
    const $element = $(element)

    let inputValues = new Map()

    $element.on(`shiny:inputchanged${this.constructor.namespace}`, (event) => {
      console.log(event)

      if (!event.el || event.priority === 'event') {
        return
      }

      if (event.el.id === element.id) {
        // Shiny.setInputValue(element.id, value, { priority: 'event' })
        event.preventDefault()
        return
      }

      if (element.contains(event.el)) {
        inputValues.set(event.name, event.value)
        event.preventDefault()
      }
    })

    $element.on(`click${this.constructor.namespace}`, this.selectors.submit, (event) => {
      event.preventDefault()

      for (const [key, value] of inputValues.entries()) {
        console.log(`${key}: ${value}`)
        Shiny.setInputValue(key, value, { priority: 'event' })
      }
    })
  }

  getValue(element) {
    return null
  }

  receiveMessage(element, data) {
    const $element = $(element)

    if (data.submit === true) {
      $element.trigger(`submit${namespace}`)
    }
  }
}

export default FormInputBinding
