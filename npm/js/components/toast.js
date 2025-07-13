import $ from 'jquery'
import { renderContentAsync } from 'Shiny'

import { addCustomMessageHandler, registerBinding } from '../utils'
import { InputBinding } from '../bindings/inputs/'

class Toast extends bootstrap.Toast {
  constructor(toast) {
    super(toast, { autoHide: false })
  }

  get state() {
    return this.isShown() ? 'shown' : 'hidden'
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
      toast.show()
    } else if (data.method === 'hide') {
      toast.hide()
    }
  }
}

Shiny.addCustomMessageHandler("yonder:toast", (msg) => {
  let _show = function(data) {
    document.querySelector(".yonder-toasts")
      .insertAdjacentHTML("beforeend", data.content);

    $(".yonder-toasts > .toast:last-child").toast("show");
  };

  let _close = function(data) {
    let toasts = document.querySelectorAll(".yonder-toasts .toast");

    if (toasts.length) {
      $(toasts).toast("hide");
    }
  };

  if (!msg.type) {
    return;
  }

  if (msg.type === "show") {
    _show(msg.data);
  } else if (msg.type === "close") {
    _close(msg.data);
  } else {
    console.warn(`no toast ${ msg.type } method`);
  }
});

Toast.addMessageHandlers()

registerBinding(ToastInputBinding)

export {
  Toast,
  ToastInputBinding
}
