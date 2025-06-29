import $ from 'jquery'

import InputBinding from './input.js'

class ButtonInputBinding extends InputBinding {
  static get type() {
    return 'button'
  }

  get events() {
    return ['click']
  }
}

export default ButtonInputBinding
