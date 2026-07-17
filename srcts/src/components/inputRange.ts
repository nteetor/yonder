import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type RangeReceiveMessageData = {
  value?: number
  disable?: boolean
}

class RangeInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-range')
  }

  override getValue(el: HTMLElement): number {
    return Number($(el).find('.form-range').val())
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('change.bsidesRangeInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesRangeInputBinding')
  }

  override getState(el: HTMLElement): { value: number } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(el: HTMLElement, data: RangeReceiveMessageData): void {
    const $el = $(el)
    const $value = $el.find('.form-range')

    if (hasDefinedProperty(data, 'value')) {
      $value.val(data.value!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      $value.prop('disabled', data.disable!)
    }

    $el.trigger('change')
  }
}

registerBinding(RangeInputBinding, 'range')

export { RangeInputBinding }
export type { RangeReceiveMessageData }
