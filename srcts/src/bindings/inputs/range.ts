import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface RangeMessage {
  value?: number
  disable?: boolean
}

class RangeInputBinding extends InputBinding {
  static override get type(): string {
    return 'range'
  }

  override get events(): BindingEvent[] {
    return ['change']
  }

  get selectors(): { value: string } {
    return {
      value: '.form-range'
    }
  }

  override getValue(element: HTMLElement): number {
    return Number($(element).find(this.selectors.value).val())
  }

  override receiveMessage(element: HTMLElement, data: RangeMessage): void {
    const $element = $(element)
    const $value = $element.find(this.selectors.value)

    if (Object.hasOwn(data, 'value')) {
      $value.val(data.value!)
    }

    if (Object.hasOwn(data, 'disable')) {
      $value.prop('disable', data.disable!)
    }

    $element.trigger('change')
  }
}

export default RangeInputBinding
