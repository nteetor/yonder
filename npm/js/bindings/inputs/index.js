import ButtonInputBinding from './button.js'
import CheckboxInputBinding from './checkbox.js'
import CheckboxGroupInputBinding from './checkbox-group.js'
import FormInputBinding from './form.js'
import LinkInputBinding from './link.js'
import ListGroupInputBinding from './list-group.js'
import MenuInputBinding from './menu.js'

function registerInputBindings() {
  if (Shiny) {
    const inputBindings = Shiny.inputBindings

    inputBindings.register(new ButtonInputBinding(), ButtonInputBinding.type)
    inputBindings.register(new CheckboxInputBinding(), CheckboxInputBinding.type)
    inputBindings.register(new CheckboxGroupInputBinding(), CheckboxGroupInputBinding.type)
    inputBindings.register(new FormInputBinding(), FormInputBinding.type)
    inputBindings.register(new LinkInputBinding(), LinkInputBinding.type)
    inputBindings.register(new ListGroupInputBinding(), ListGroupInputBinding.type)
    inputBindings.register(new MenuInputBinding(), MenuInputBinding.type)
  }
}

export {
  registerInputBindings
}