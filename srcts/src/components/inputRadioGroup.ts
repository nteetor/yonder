import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type RadioGroupReceiveMessageData = {
  options?: string
  select?: string[]
  disable?: string[]
}

class RadioGroupInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-radio-group')
  }

  override getValue(el: HTMLElement): string | number | string[] | undefined {
    return $(el)
      .find('.form-check-input,.btn-check')
      .filter(':checked')
      .val()
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('change.bsidesRadioGroupInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesRadioGroupInputBinding')
  }

  override getState(el: HTMLElement): { value: unknown } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: RadioGroupReceiveMessageData
  ): void {
    const $el = $(el)

    if (hasDefinedProperty(data, 'options')) {
      $el.html(data.options!)
    }

    const $values = $el.find<HTMLInputElement>('.form-check-input,.btn-check')

    if (hasDefinedProperty(data, 'select')) {
      $values.prop('checked', false)

      $values
        .filter((i, e) => data.select!.includes(e.value))
        .prop('checked', true)
    }

    if (hasDefinedProperty(data, 'disable')) {
      $values.prop('disabled', false)

      $values
        .filter((i, e) => data.disable!.includes(e.value))
        .prop('disabled', true)
    }

    $el.trigger('change')
  }
}

registerBinding(RadioGroupInputBinding, 'radiogroup')

export { RadioGroupInputBinding }
export type { RadioGroupReceiveMessageData }
