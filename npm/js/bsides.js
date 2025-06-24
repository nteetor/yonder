//import ButtonInput from './inputs/button.js'
import CheckboxInput from './inputs/checkbox.js'
//import CheckbuttonInput from './inputs/checkbutton.js'
//import LinkInput from './inputs/link.js'

if (Shiny) {
  Shiny.inputBindings.register(CheckboxInput)
}

export default {
//  ButtonInput,
  CheckboxInput,
//  CheckbuttonInput,
//  LinkInput
}
