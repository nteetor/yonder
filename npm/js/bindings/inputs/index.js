import { registerInput } from '../../utils'

import ButtonInputBinding from './button.js'
import CheckboxInputBinding from './checkbox.js'
import CheckboxGroupInputBinding from './checkbox-group.js'
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
  registerInput(ButtonInputBinding)
  registerInput(CheckboxInputBinding)
  registerInput(CheckboxGroupInputBinding)
  registerInput(FormInputBinding)
  registerInput(LinkInputBinding)
  registerInput(ListGroupInputBinding)
  registerInput(MenuInputBinding)
  registerInput(RadioGroupInputBinding)
  registerInput(RangeInputBinding)
  registerInput(SelectInputBinding)
  registerInput(TextInputBinding)
  registerInput(TextGroupInputBinding)
}

export {
  registerInputs
}