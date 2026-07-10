// Modeled on Shiny's ActionButtonInputBinding.

import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type ButtonReceiveMessageData = {
  text?: string
  disable?: boolean
}

class ButtonInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-button')
  }

  override getValue(el: HTMLElement): number {
    return Number($(el).data('bsides-clicks')) || 0
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el
    return 'bsides.button'
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('click.bsidesButtonInputBinding', () => {
      const clicks = Number($(el).data('bsides-clicks')) || 0
      $(el).data('bsides-clicks', clicks + 1)
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesButtonInputBinding')
  }

  override getState(el: HTMLElement): { value: number } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: ButtonReceiveMessageData
  ): void {
    const button = el as HTMLButtonElement

    if (hasDefinedProperty(data, 'text')) {
      button.innerHTML = data.text!
    }

    if (hasDefinedProperty(data, 'disable')) {
      button.disabled = data.disable!
    }
  }
}

registerBinding(ButtonInputBinding, 'button')

export { ButtonInputBinding }
export type { ButtonReceiveMessageData }
