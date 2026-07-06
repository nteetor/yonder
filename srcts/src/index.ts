import { initialize } from './utils'
import { registerInputs } from './bindings/inputs'

import './components/toast'
import './components/modal'

initialize(() => {
  registerInputs()
})
