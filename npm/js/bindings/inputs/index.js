import CheckboxInputBinding from './checkbox.js'
import CheckboxButtonInputBinding from './checkbox-button.js'
import FormInputBinding from './form.js'

function registerInputBindings() {
  if (Shiny) {
    const inputBindings = Shiny.inputBindings

    inputBindings.register(new CheckboxInputBinding(), CheckboxInputBinding.type)
    inputBindings.register(new CheckboxButtonInputBinding(), CheckboxButtonInputBinding.type)
    inputBindings.register(new FormInputBinding(), FormInputBinding.type)
  }
}

export {
  registerInputBindings
}