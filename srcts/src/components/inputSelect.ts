import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type SelectHTMLElement = HTMLSelectElement

type SelectReceiveMessageData = {
  options?: string
  select?: string
  disable?: string[]
}

class SelectInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-select')
  }

  override getValue(el: SelectHTMLElement): string {
    return el.value
  }

  setValue(el: SelectHTMLElement, value: string): void {
    el.value = value
  }

  override subscribe(
    el: SelectHTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('change.bsidesSelectInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: SelectHTMLElement): void {
    $(el).off('.bsidesSelectInputBinding')
  }

  override getState(el: SelectHTMLElement): { value: string } {
    return {
      value: el.value
    }
  }

  override receiveMessage(
    el: SelectHTMLElement,
    data: SelectReceiveMessageData
  ): void {
    const $el = $(el)

    if (hasDefinedProperty(data, 'options')) {
      $el.html(data.options!)
    }

    if (hasDefinedProperty(data, 'select')) {
      this.setValue(el, data.select!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      const $options = $el.find<HTMLOptionElement>('option')

      $options.prop('disabled', false)

      $options
        .filter((i, e) => data.disable!.includes(e.value))
        .prop('disabled', true)
    }

    $el.trigger('change')
  }
}

registerBinding(SelectInputBinding, 'select')

export { SelectInputBinding }
export type { SelectHTMLElement, SelectReceiveMessageData }
