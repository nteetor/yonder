import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface RadioGroupMessage {
  options?: string
  select?: string[]
  disable?: string[]
}

class RadioGroupInputBinding extends InputBinding {
  static override get type(): string {
    return 'radiogroup'
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

  override getValue(element: HTMLElement): string | number | string[] | undefined {
    return $(element)
      .find(this.selectors.value)
      .filter(':checked')
      .val()
  }

  override receiveMessage(element: HTMLElement, data: RadioGroupMessage): void {
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

export default RadioGroupInputBinding
