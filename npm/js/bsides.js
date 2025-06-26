//import ButtonInput from './inputs/button.js'
import CheckboxInput from './inputs/checkbox.js'
import CheckboxButtonInput from './inputs/checkbox-button.js'
//import LinkInput from './inputs/link.js'

if (Shiny) {
  Shiny.inputBindings.register(CheckboxInput)
  Shiny.inputBindings.register(CheckboxButtonInput)
}

export default {
//  ButtonInput,
  CheckboxInput,
  CheckboxButtonInput
//  LinkInput
}
