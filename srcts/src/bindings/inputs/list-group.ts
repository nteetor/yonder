import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

class ListGroupInputBinding extends InputBinding {
  static override get type(): string {
    return 'listgroup'
  }

  override get events(): BindingEvent[] {
    return ['click']
  }

  get selectors(): { choice: string; value: string } {
    return {
      choice: '.list-group-item-action',
      value: '.list-group-item-action'
    }
  }

  get data(): { value: string } {
    return {
      value: `${this.ctor.prefix}-value`
    }
  }

  override initialize(element: HTMLElement): void {
    const $element = $(element)

    $element.on('click', this.selectors.choice, (event) => {
      const $choice = $(event.currentTarget)

      $choice.toggleClass('active')
    })
  }

  override getValue(element: HTMLElement): Array<string | null> {
    return $(element)
      .find(`${this.selectors.value}.active`)
      .map((i, el) => el.getAttribute(`data-${this.data.value}`))
      .get()
  }
}

export default ListGroupInputBinding
