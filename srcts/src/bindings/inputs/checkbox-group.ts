import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface CheckboxGroupMessage {
  options?: string
  select?: string[]
  disable?: string[]
}

class CheckboxGroupInputBinding extends InputBinding {
  static override get type(): string {
    return 'checkboxgroup'
  }

  override get events(): BindingEvent[] {
    return ['change']
  }

  get selectors(): { choice: string; value: string } {
    return {
      choice: '.form-check-label,.btn',
      value: '.form-check-input,.btn-check'
    }
  }

  override getType(element: HTMLElement): string | null {
    void element
    return `${this.ctor.prefix}${this.ctor.namespace}`
  }

  override getValue(element: HTMLElement): string[] {
    return $(element)
      .find<HTMLInputElement>(this.selectors.value)
      .filter(':checked')
      .map((i, el) => el.value)
      .get()
  }

  override receiveMessage(
    element: HTMLElement,
    data: CheckboxGroupMessage
  ): void {
    const $element = $(element)
    const $values = $element.find<HTMLInputElement>(this.selectors.value)

    if (Object.hasOwn(data, 'options')) {
      $element.find('.form-check').remove()
      $element.html(data.options!)
    }

    if (Object.hasOwn(data, 'select')) {
      $values.prop('checked', false)

      $values
        .filter((i, e) => data.select!.includes(e.value))
        .prop('checked', true)
    }

    if (Object.hasOwn(data, 'disable')) {
      $values.prop('disabled', false)

      $values
        .filter((i, e) => data.disable!.includes(e.value))
        .prop('disabled', true)
    }

    $element.trigger('change')
  }
}

export default CheckboxGroupInputBinding
