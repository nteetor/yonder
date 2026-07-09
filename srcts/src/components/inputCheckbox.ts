import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type CheckboxReceiveMessageData = {
  choice?: string
  value?: boolean
  disable?: boolean
}

class CheckboxInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-checkbox')
  }

  override getValue(el: HTMLElement): boolean {
    return $(el).children('.form-check-input').prop('checked') as boolean
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('change.bsidesCheckboxInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesCheckboxInputBinding')
  }

  override getState(el: HTMLElement): { value: boolean } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: CheckboxReceiveMessageData
  ): void {
    const $el = $(el)

    if (hasDefinedProperty(data, 'choice')) {
      $el.find('.form-check-label').html(data.choice!)
    }

    if (hasDefinedProperty(data, 'value')) {
      $el.find('.form-check-input').prop('checked', data.value!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      $el.find('.form-check-input').prop('disabled', data.disable!)
    }

    $el.trigger('change')
  }
}

registerBinding(CheckboxInputBinding, 'checkbox')

export { CheckboxInputBinding }
export type { CheckboxReceiveMessageData }
