import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent, RatePolicy } from './input'

interface TextMessage {
  value?: string
  disable?: boolean
}

class TextInputBinding extends InputBinding {
  static override get type(): string {
    return 'text'
  }

  override get events(): BindingEvent[] {
    return [
      'keyup',
      'input',
      'change'
    ]
  }

  get selectors(): { value: string } {
    return {
      value: 'input'
    }
  }

  override getValue(element: HTMLElement): string {
    return (element as HTMLInputElement).value
  }

  override getRatePolicy(element: HTMLElement): RatePolicy {
    void element
    return {
      policy: 'debounce',
      delay: 250
    }
  }

  override receiveMessage(element: HTMLElement, data: TextMessage): void {
    const $element = $(element)

    if (Object.hasOwn(data, 'value')) {
      $element.val(data.value!)
    }

    if (Object.hasOwn(data, 'disable')) {
      $element.prop('disabled', data.disable!)
    }

    $element.trigger('change')
  }
}

export default TextInputBinding
