import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

class LinkInputBinding extends InputBinding {
  static override get type(): string {
    return 'link'
  }

  override get events(): BindingEvent[] {
    return ['click']
  }

  get data(): { clicks: string } {
    return {
      clicks: `${this.ctor.prefix}-clicks`
    }
  }

  override initialize(element: HTMLElement): void {
    const $element = $(element)

    $element.data(this.data.clicks, 0)

    $element.on(`click${this.ctor.namespace}`, () => {
      const clicks = Number($element.data(this.data.clicks))
      $element.data(this.data.clicks, clicks + 1)
    })
  }

  override getType(element: HTMLElement): string | null {
    void element
    return `${this.ctor.prefix}${this.ctor.namespace}`
  }

  override getValue(element: HTMLElement): number {
    return $(element).data(this.data.clicks) as number
  }
}

export default LinkInputBinding
