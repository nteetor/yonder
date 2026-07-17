import $ from 'jquery'
import { Toast as BootstrapToast } from 'bootstrap'

import {
  InputBinding,
  registerBinding,
  addCustomMessageHandler,
  hasDefinedProperty,
  Shiny
} from './_utils'

interface ToastAddMessage {
  target?: string
  // The R side renders the toast to an HTML string with doRenderTags().
  toast: string | ShinyRenderContent
}

interface ToastReceiveMessageData {
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

      if (!container || !Shiny) {
        return
      }

      await Shiny.renderContentAsync(container, data.toast, 'beforeEnd')
    })
  }
}

class ToastInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-toast')
  }

  override initialize(el: HTMLElement): void {
    new Toast(el)
  }

  override getValue(el: HTMLElement): string | undefined {
    const toast = Toast.getInstance(el) as Toast | null

    if (!toast) {
      return undefined
    }

    return toast.state
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on(
      'shown.bs.toast.bsidesToastInputBinding hidden.bs.toast.bsidesToastInputBinding',
      () => {
        callback(false)
      }
    )
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesToastInputBinding')
  }

  override receiveMessage(el: HTMLElement, data: ToastReceiveMessageData): void {
    const toast = Toast.getInstance(el) as Toast | null

    if (!toast) {
      return
    }

    if (data.method === 'show') {
      toast.show(hasDefinedProperty(data, 'duration') ? data.duration : undefined)
    } else if (data.method === 'hide') {
      toast.hide()
    }
  }
}

Toast.addMessageHandlers()

registerBinding(ToastInputBinding, 'toast')

export { Toast, ToastInputBinding }
export type { ToastAddMessage, ToastReceiveMessageData }
