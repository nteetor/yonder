import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface SelectMessage {
  options?: string
  select?: string
  disable?: string[]
}

class SelectInputBinding extends InputBinding {
  static override get type(): string {
    return 'select'
  }

  override get events(): BindingEvent[] {
    return ['change']
  }

  get selectors(): { value: string } {
    return {
      value: 'option'
    }
  }

  override getValue(element: HTMLElement): string {
    return (element as HTMLSelectElement).value
  }

  override receiveMessage(element: HTMLElement, data: SelectMessage): void {
    const $element = $(element)

    if (Object.hasOwn(data, 'options')) {
      $element.find(this.selectors.value).remove()
      $element.html(data.options!)
    }

    if (Object.hasOwn(data, 'select')) {
      $element.val(data.select!)
    }

    if (Object.hasOwn(data, 'disable')) {
      const $values = $element.find<HTMLOptionElement>('option')
      $values.prop('disabled', false)

      $values
        .filter((i, e) => data.disable!.includes(e.value))
        .prop('disabled', true)
    }

    $element.trigger('change')
  }
}

export default SelectInputBinding
