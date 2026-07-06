import { Toast as BootstrapToast } from 'bootstrap'

import { addCustomMessageHandler, registerBinding } from '../utils'
import { InputBinding } from '../bindings/inputs'
import type { BindingEvent } from '../bindings/inputs/input'

interface ToastAddMessage {
  target?: string
  toast: ShinyRenderContent
}

interface ToastReceiveMessage {
  method?: 'show' | 'hide'
  duration?: number
}

class Toast extends BootstrapToast {
  constructor(toast: Element) {
    super(toast, {})
  }

  get state(): string {
    return this.isShown() ? 'shown' : 'hidden'
  }

  override show(duration?: number): void {
    if (duration) {
      const config = (this as unknown as {
        _config: { delay: number; autohide: boolean }
      })._config

      config.delay = duration
      config.autohide = true
    }

    super.show()
  }

  static addMessageHandlers(): void {
    addCustomMessageHandler('toastAdd', async (data: ToastAddMessage) => {
      if (!data.target) {
        return
      }

      const container = document.getElementById(data.target)

      if (!container || !window.Shiny) {
        return
      }

      await window.Shiny.renderContentAsync(container, data.toast, 'beforeend')
    })
  }
}

class ToastInputBinding extends InputBinding {
  static override get type(): string {
    return 'toast'
  }

  override get events(): BindingEvent[] {
    return [
      'shown.bs.toast',
      'hidden.bs.toast'
    ]
  }

  override initialize(element: HTMLElement): void {
    new Toast(element)
  }

  override getValue(element: HTMLElement): string | undefined {
    const toast = Toast.getInstance(element) as Toast | null

    if (!toast) {
      return undefined
    }

    return toast.state
  }

  override receiveMessage(element: HTMLElement, data: ToastReceiveMessage): void {
    const toast = Toast.getInstance(element) as Toast | null

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
