import $ from 'jquery'
import { renderContentAsync } from 'Shiny'

import { addCustomMessageHandler, registerBinding } from '../utils'
import { InputBinding } from '../bindings/inputs/'

class Toast extends bootstrap.Toast {
  constructor(toast) {
    super(toast, {})
  }

  get state() {
    return this.isShown() ? 'shown' : 'hidden'
  }

  show(duration) {
    if (duration) {
      this._config.delay = duration
      this._config.autohide = true
    }

    super.show()
  }

  static addMessageHandlers() {
    addCustomMessageHandler('toastAdd', async function(data) {
      if (!data.target) {
        return
      }

      const container = document.getElementById(data.target)

      if (!container) {
        return
      }

      await renderContentAsync(container, data.toast, 'beforeend')
    })
  }
}

class ToastInputBinding extends InputBinding {
  static get type() {
    return 'toast'
  }

  get events() {
    return [
      'shown.bs.toast',
      'hidden.bs.toast'
    ]
  }

  initialize(element) {
    new Toast(element)
  }

  getValue(element) {
    const toast = Toast.getInstance(element)

    if (!toast) {
      return
    }

    return toast.state
  }

  receiveMessage(element, data) {
    const toast = Toast.getInstance(element)

    if (!toast) {
      return
    }

    if (data.method === 'show') {
      toast.show(data.duration)
    } else if (data.method === 'hide') {
      toast.hide()
    }
  }
}

Toast.addMessageHandlers()

registerBinding(ToastInputBinding)

export {
  Toast,
  ToastInputBinding
}
