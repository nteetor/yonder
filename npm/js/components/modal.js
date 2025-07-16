import { unbindAll, renderContentAsync } from 'Shiny'

import { addCustomMessageHandler, registerBinding } from '../utils'
import { InputBinding } from '../bindings/inputs'

class Modal extends bootstrap.Modal {

  isShown() {
    return this._isShown
  }

  static addMessageHandlers() {
    addCustomMessageHandler('modalShow', (data) => {
      if (typeof data.modal === 'object') {
        this.showOrInsertModal(data.modal)
      } else {
        const el = document.getElementById(data.modal)

        if (!el) {
          return
        }

        const modal = Modal.getOrCreateInstance(el)

        modal.show()
      }
    })
  }

  static async showOrInsertModal(content) {
    const el = document.createElement('div')
    el.innerHTML = content.html

    const id = el.firstChild && el.firstChild.id
    const existing = document.getElementById(id)

    if (existing) {
      unbindAll(existing, true)
      existing.remove()
    }

    await renderContentAsync(document.body, content, 'beforeend')

    const modal = new Modal(document.getElementById(id))

    modal.show()
  }
}

class ModalInputBinding extends InputBinding {
  static get type() {
    return 'modal'
  }

  get events() {
    return [
      'shown.bs.modal',
      'hidden.bs.modal'
    ]
  }

  getValue(element) {
    const modal = Modal.getInstance(element)

    if (!modal) {
      return null
    }

    return modal.isShown() ? 'shown' : 'hidden'
  }
}

Modal.addMessageHandlers()

registerBinding(ModalInputBinding)

export default {
  Modal,
  ModalInputBinding
}
