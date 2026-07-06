import { Modal as BootstrapModal } from 'bootstrap'

import { addCustomMessageHandler, registerBinding } from '../utils'
import { InputBinding } from '../bindings/inputs'
import type { BindingEvent } from '../bindings/inputs/input'

interface ModalShowMessage {
  modal: string | ShinyRenderContent
}

class Modal extends BootstrapModal {
  isShown(): boolean {
    return (this as unknown as { _isShown: boolean })._isShown
  }

  static addMessageHandlers(): void {
    addCustomMessageHandler('modalShow', (data: ModalShowMessage) => {
      if (typeof data.modal === 'object') {
        Modal.showOrInsertModal(data.modal)
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

  static async showOrInsertModal(content: ShinyRenderContent): Promise<void> {
    const el = document.createElement('div')
    el.innerHTML = content.html

    const id = el.firstChild && (el.firstChild as HTMLElement).id

    if (!id || !window.Shiny) {
      return
    }

    const existing = document.getElementById(id)

    if (existing) {
      window.Shiny.unbindAll(existing, true)
      existing.remove()
    }

    await window.Shiny.renderContentAsync(document.body, content, 'beforeend')

    const target = document.getElementById(id)

    if (!target) {
      return
    }

    const modal = new Modal(target)

    modal.show()
  }
}

class ModalInputBinding extends InputBinding {
  static override get type(): string {
    return 'modal'
  }

  override get events(): BindingEvent[] {
    return [
      'shown.bs.modal',
      'hidden.bs.modal'
    ]
  }

  override getValue(element: HTMLElement): string | null {
    const modal = Modal.getInstance(element) as Modal | null

    if (!modal) {
      return null
    }

    return modal.isShown() ? 'shown' : 'hidden'
  }
}

Modal.addMessageHandlers()

registerBinding(ModalInputBinding)

export {
  Modal,
  ModalInputBinding
}
