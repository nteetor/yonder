import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface CheckboxMessage {
  choice?: string
  value?: boolean
  disable?: boolean
}

class CheckboxInputBinding extends InputBinding {
  static override get type(): string {
    return 'checkbox'
  }

  override get events(): BindingEvent[] {
    return ['change']
  }

  get selectors(): { label: string; value: string } {
    return {
      label: '.form-check-label',
      value: '.form-check-input'
    }
  }

  override getValue(element: HTMLElement): boolean {
    return $(element).children(this.selectors.value).prop('checked') as boolean
  }

  override receiveMessage(element: HTMLElement, data: CheckboxMessage): void {
    const $element = $(element)
    const $label = $element.find(this.selectors.label)
    const $value = $element.find(this.selectors.value)

    if (Object.hasOwn(data, 'choice')) {
      $label.html(data.choice!)
    }

    if (Object.hasOwn(data, 'value')) {
      $value.prop('checked', data.value!)
    }

    if (Object.hasOwn(data, 'disable')) {
      $value.prop('disabled', data.disable!)
    }

    $element.trigger('change')
  }
}

export default CheckboxInputBinding
