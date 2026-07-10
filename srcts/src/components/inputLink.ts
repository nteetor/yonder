import $ from 'jquery'

import { InputBinding, registerBinding } from './_utils'

type LinkReceiveMessageData = {
  // update_link() does not drop NULLs, so label may arrive as null.
  label?: string | null
}

class LinkInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-link')
  }

  override getValue(el: HTMLElement): number {
    return Number($(el).data('bsides-clicks')) || 0
  }

  // Matches the input handler registered by the R side.
  override getType(el: HTMLElement): string | null {
    void el
    return 'bsides.link'
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    $(el).on('click.bsidesLinkInputBinding', () => {
      const clicks = Number($(el).data('bsides-clicks')) || 0
      $(el).data('bsides-clicks', clicks + 1)
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesLinkInputBinding')
  }

  override getState(el: HTMLElement): { value: number } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(el: HTMLElement, data: LinkReceiveMessageData): void {
    if (data.label != null) {
      el.innerHTML = data.label
    }
  }
}

registerBinding(LinkInputBinding, 'link')

export { LinkInputBinding }
export type { LinkReceiveMessageData }
