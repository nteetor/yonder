import { registerBinding } from '../../utils'

import InputBinding from './input.js'

import ButtonInputBinding from './button.js'
import CheckboxInputBinding from './checkbox.js'
import CheckboxGroupInputBinding from './checkbox-group.js'
import MultiSelectInputBinding from './multi-select.js'
import FormInputBinding from './form.js'
import LinkInputBinding from './link.js'
import ListGroupInputBinding from './list-group.js'
import MenuInputBinding from './menu.js'
import RadioGroupInputBinding from './radio-group.js'
import RangeInputBinding from './range.js'
import SelectInputBinding from './select.js'
import TextInputBinding from './text.js'
import TextGroupInputBinding from './text-group.js'

function registerInputs() {
  registerBinding(ButtonInputBinding)
  registerBinding(CheckboxInputBinding)
  registerBinding(CheckboxGroupInputBinding)
  registerBinding(FormInputBinding)
  registerBinding(LinkInputBinding)
  registerBinding(ListGroupInputBinding)
  registerBinding(MenuInputBinding)
  registerBinding(RadioGroupInputBinding)
  registerBinding(RangeInputBinding)
  registerBinding(SelectInputBinding)
  registerBinding(TextInputBinding)
  registerBinding(TextGroupInputBinding)
}

export {
  InputBinding,
  registerInputs
}