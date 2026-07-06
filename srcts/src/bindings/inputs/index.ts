import { registerBinding } from '../../utils'

import InputBinding from './input'

import ButtonInputBinding from './button'
import CheckboxInputBinding from './checkbox'
import CheckboxGroupInputBinding from './checkbox-group'
import FormInputBinding from './form'
import LinkInputBinding from './link'
import ListGroupInputBinding from './list-group'
import MenuInputBinding from './menu'
import RadioGroupInputBinding from './radio-group'
import RangeInputBinding from './range'
import SelectInputBinding from './select'
import TextInputBinding from './text'
import TextGroupInputBinding from './text-group'

// Registers itself at load time.
import './multi-select'

function registerInputs(): void {
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
