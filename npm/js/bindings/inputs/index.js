import ButtonInputBinding from './button.js'
import CheckboxInputBinding from './checkbox.js'
import CheckboxButtonInputBinding from './checkbox-button.js'
import FormInputBinding from './form.js'
import LinkInputBinding from './link.js'

function registerInputBindings() {
  if (Shiny) {
    const inputBindings = Shiny.inputBindings

    inputBindings.register(new ButtonInputBinding(), ButtonInputBinding.type)
    inputBindings.register(new CheckboxInputBinding(), CheckboxInputBinding.type)
    inputBindings.register(new CheckboxButtonInputBinding(), CheckboxButtonInputBinding.type)
    inputBindings.register(new FormInputBinding(), FormInputBinding.type)
    inputBindings.register(new LinkInputBinding(), LinkInputBinding.type)
  }
}

export {
  registerInputBindings
}