import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type MenuReceiveMessageData = {
  label?: string
  select?: string
  disable?: string[]
}

class MenuInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-menu')
  }

  override getValue(el: HTMLElement): unknown {
    return $(el).data('bsides-value')
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    const $el = $(el)

    $el.on('click.bsidesMenuInputBinding', '.dropdown-item', (event) => {
      $el.data('bsides-value', (event.currentTarget as HTMLButtonElement).value)
      callback(false)
    })

    // Server updates via receiveMessage() are announced with a change event.
    $el.on('change.bsidesMenuInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesMenuInputBinding')
  }

  override getState(el: HTMLElement): { value: unknown } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(el: HTMLElement, data: MenuReceiveMessageData): void {
    const $el = $(el)

    if (hasDefinedProperty(data, 'label')) {
      $el.children('.dropdown-toggle').html(data.label!)
    }

    if (hasDefinedProperty(data, 'disable')) {
      const $choices = $el.find<HTMLButtonElement>('.dropdown-item')

      $choices.prop('disabled', false).removeClass('disabled')

      $choices
        .filter((i, e) => data.disable!.includes(e.value))
        .prop('disabled', true)
        .addClass('disabled')
    }

    if (hasDefinedProperty(data, 'select')) {
      $el.data('bsides-value', data.select!)
      $el.trigger('change')
    }
  }
}

registerBinding(MenuInputBinding, 'menu')

export { MenuInputBinding }
export type { MenuReceiveMessageData }
