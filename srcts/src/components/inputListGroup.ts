import $ from 'jquery'

import { InputBinding, registerBinding, hasDefinedProperty } from './_utils'

type ListGroupReceiveMessageData = {
  select?: string[]
  disable?: string[]
}

class ListGroupInputBinding extends InputBinding {
  get selectors(): { choice: string } {
    return {
      choice: '.list-group-item-action'
    }
  }

  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-listgroup')
  }

  override getValue(el: HTMLElement): Array<string | null> {
    return $(el)
      .find(`${this.selectors.choice}.active`)
      .map((i, e) => e.getAttribute('data-bsides-value'))
      .get()
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    const $el = $(el)

    $el.on(
      'click.bsidesListGroupInputBinding',
      this.selectors.choice,
      (event) => {
        $(event.currentTarget).toggleClass('active')
        callback(false)
      }
    )

    // Server updates via receiveMessage() are announced with a change event.
    $el.on('change.bsidesListGroupInputBinding', () => {
      callback(false)
    })
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesListGroupInputBinding')
  }

  override getState(el: HTMLElement): { value: Array<string | null> } {
    return {
      value: this.getValue(el)
    }
  }

  override receiveMessage(
    el: HTMLElement,
    data: ListGroupReceiveMessageData
  ): void {
    const $el = $(el)
    const $choices = $el.find(this.selectors.choice)

    const valueOf = (e: HTMLElement) => e.getAttribute('data-bsides-value') ?? ''

    if (hasDefinedProperty(data, 'select')) {
      $choices.removeClass('active')

      $choices
        .filter((i, e) => data.select!.includes(valueOf(e)))
        .addClass('active')
    }

    if (hasDefinedProperty(data, 'disable')) {
      $choices.removeClass('disabled').prop('disabled', false)

      $choices
        .filter((i, e) => data.disable!.includes(valueOf(e)))
        .addClass('disabled')
        .prop('disabled', true)
    }

    $el.trigger('change')
  }
}

registerBinding(ListGroupInputBinding, 'listgroup')

export { ListGroupInputBinding }
export type { ListGroupReceiveMessageData }
