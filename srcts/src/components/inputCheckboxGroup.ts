import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type CheckboxGroupReceiveMessageData = {
  options?: string
  select?: string[]
  disable?: string[]
}

class CheckboxGroupInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-checkbox-group')
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el
    return 'bsides.checkboxgroup'
  }

  override getValue(el: HTMLElement): string[] {
    return $(el)
      .find<HTMLInputElement>('.form-check-input,.btn-check')
      .filter(':checked')
      .map((i, e) => e.value)
      .get()
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('change.bsidesCheckboxGroupInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesCheckboxGroupInputBinding')
  }

  override getState(el: HTMLElement): { value: string[] } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: CheckboxGroupReceiveMessageData
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

registerBinding(CheckboxGroupInputBinding, 'checkboxgroup')

export { CheckboxGroupInputBinding }
export type { CheckboxGroupReceiveMessageData }
