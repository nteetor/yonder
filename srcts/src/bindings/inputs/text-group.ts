import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent, RatePolicy } from './input'

interface TextGroupMessage {
  value?: string
  disable?: boolean
}

class TextGroupInputBinding extends InputBinding {
  static override get type(): string {
    return 'textgroup'
  }

  override get events(): BindingEvent[] {
    return [
      'keyup',
      'input',
      'change'
    ]
  }

  get selectors(): { value: string; text: string } {
    return {
      value: 'input',
      text: '.input-group-text'
    }
  }

  override getValue(element: HTMLElement): string | null {
    const $element = $(element)

    if (!$element.find(this.selectors.value).val()) {
      return null
    }

    return $element
      .find(`${this.selectors.text},${this.selectors.value}`)
      .map((i, e) => e.innerText || (e as HTMLInputElement).value || '')
      .get()
      .join('')
  }

  override getRatePolicy(element: HTMLElement): RatePolicy {
    void element
    return {
      policy: 'debounce',
      delay: 250
    }
  }

  override receiveMessage(element: HTMLElement, data: TextGroupMessage): void {
    const $element = $(element)
    const $value = $element.find(this.selectors.value)

    if (Object.hasOwn(data, 'value')) {
      $value.val(data.value!)
    }

    if (Object.hasOwn(data, 'disable')) {
      $value.prop('disabled', data.disable!)
    }

    $element.trigger('change')
  }
}

export default TextGroupInputBinding
