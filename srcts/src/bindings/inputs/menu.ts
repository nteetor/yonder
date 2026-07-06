import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

class MenuInputBinding extends InputBinding {
  static override get type(): string {
    return 'menu'
  }

  override get events(): BindingEvent[] {
    return [
      { type: 'click', selector: this.selectors.choice }
    ]
  }

  get selectors(): { choice: string; value: string } {
    return {
      choice: '.dropdown-item',
      value: '.dropdown-item'
    }
  }

  get data(): { value: string } {
    return {
      value: `${this.ctor.prefix}-value`
    }
  }

  override initialize(element: HTMLElement): void {
    const $element = $(element)

    $element.on('click', this.selectors.value, (event) => {
      $element.data(
        this.data.value,
        (event.currentTarget as HTMLButtonElement).value
      )
    })
  }

  override getValue(element: HTMLElement): unknown {
    return $(element).data(this.data.value)
  }
}

export default MenuInputBinding
