// Modeled on Shiny's TextInputBinding (srcts/src/bindings/input/text.ts).

import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type TextHTMLElement = HTMLInputElement

type TextReceiveMessageData = {
  value?: TextHTMLElement['value']
  disable?: boolean
}

class TextInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-text')
  }

  override getValue(el: TextHTMLElement): TextHTMLElement['value'] {
    return el.value
  }

  setValue(el: TextHTMLElement, value: string): void {
    el.value = value
  }

  override subscribe(
    el: TextHTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    const $el = $(el)

    // Rapid-fire events defer to the rate policy (debounce); committed
    // changes are sent immediately.
    $el.on('keyup.bsidesTextInputBinding input.bsidesTextInputBinding', () => {
      callback(true)
    })

    $el.on('change.bsidesTextInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: TextHTMLElement): void {
    $(el).off('.bsidesTextInputBinding')
  }

  override getState(el: TextHTMLElement): { value: string } {
    return {
      value: el.value
    }
  }

  override receiveMessage(el: TextHTMLElement, data: TextReceiveMessageData): void {
    if (hasDefinedProperty(data, 'value')) {
      this.setValue(el, data.value!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      el.disabled = data.disable!
    }

    $(el).trigger('change')
  }

  override getRatePolicy(el: HTMLElement): { policy: 'debounce'; delay: number } {
    void el
    return {
      policy: 'debounce',
      delay: 250
    }
  }
}

registerBinding(TextInputBinding, 'text')

export { TextInputBinding }
export type { TextHTMLElement, TextReceiveMessageData }
