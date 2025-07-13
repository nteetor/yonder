import { initialize } from './utils'
import { registerInputs } from './bindings/inputs'

import './components/toast.js'

initialize(() => {
  registerInputs()
})
