import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type TextGroupReceiveMessageData = {
  value?: string
  disable?: boolean
}

class TextGroupInputBinding extends InputBinding {
  get selectors(): { value: string; text: string } {
    return {
      value: 'input',
      text: '.input-group-text'
    }
  }

  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-textgroup')
  }

  override getValue(el: HTMLElement): string | null {
    const $el = $(el)

    if (!$el.find(this.selectors.value).val()) {
      return null
    }

    return $el
      .find(`${this.selectors.text},${this.selectors.value}`)
      .map((i, e) => e.textContent || (e as HTMLInputElement).value || '')
      .get()
      .join('')
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    const $el = $(el)

    // Rapid-fire events defer to the rate policy (debounce); committed
    // changes are sent immediately.
    $el.on(
      'keyup.bsidesTextGroupInputBinding input.bsidesTextGroupInputBinding',
      () => {
        callback(true)
      }
    )

    $el.on('change.bsidesTextGroupInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesTextGroupInputBinding')
  }

  override getState(el: HTMLElement): { value: string | null } {
    return {
      value: this.getValue(el)
    }
  }

  override getRatePolicy(el: HTMLElement): { policy: 'debounce'; delay: number } {
    void el
    return {
      policy: 'debounce',
      delay: 250
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: TextGroupReceiveMessageData
  ): void {
    const $el = $(el)
    const $value = $el.find(this.selectors.value)

    if (hasDefinedProperty(data, 'value')) {
      $value.val(data.value!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      $value.prop('disabled', data.disable!)
    }

    $el.trigger('change')
  }
}

registerBinding(TextGroupInputBinding, 'textgroup')

export { TextGroupInputBinding }
export type { TextGroupReceiveMessageData }
