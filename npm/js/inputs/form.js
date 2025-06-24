import $ from 'jquery'

import Input from './input.js'
import InputStore from '../utils/input-store.js'
import ValuesMap from '../utils/values-map.js'

class FormInput extends Input {
  get name() {
    return 'form'
  }

  constructor(element) {
    super(element)

    this.value = new ValuesMap()
    this.toggle = $(element).find('')
  }

  static initialize(element) {
    super.initialize(element)

    $(element).find('.bsides-btn-submit').on('click')
  }
}

$(document).on('shiny:inputchanged.bsides', (event) => {
  if (!event.el || event.priority === 'event') {
    return;
  }

  let form = InputStore.get(element, FormInput.type)

  if (!form) {
    return
  }

  if (event.el.id === form.element.id) {
    Shiny.onInputChange(event.el.id, form.value(), { priority: 'event' })
    event.preventDefault()
    return
  }

  if (form.element.contains(event.el)) {
    form.value.set(event.name, event.value)
    event.preventDefault()
  }
})

$(document).on('click', '.bsides-btn-submit', (event) => {
  let form = InputStore.get(element, FormInput.type)

  if (!form) {
    return
  }

  form.
});

if (Shiny) {
  Shiny.inputBindings.register(FormInput.ShinyInterface())
}

export default FormInput