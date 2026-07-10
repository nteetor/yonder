import $ from 'jquery'

import {
  InputBinding,
  registerBinding,
  hasDefinedProperty,
  Shiny
} from './_utils'

type FormReceiveMessageData = {
  submit?: string
}

// A form freezes the inputs it contains: child input changes are held back
// (event.preventDefault() on shiny:inputchanged) and replayed to the server
// only when a submit button is clicked.
class FormInputBinding extends InputBinding {
  override find(scope: HTMLElement): JQuery<HTMLElement> {
    return $(scope).find('.bsides-input-form')
  }

  override getValue(el: HTMLElement): unknown {
    return $(el).data('bsides-value')
  }

  override subscribe(
    el: HTMLElement,
    callback: (allowDeferred: boolean) => void
  ): void {
    const $el = $(el)

    const inputValues = new Map<string, unknown>()

    $el.on('shiny:inputchanged.bsidesFormInputBinding', (event) => {
      const inputEvent = event as unknown as ShinyInputChangedEvent

      if (!inputEvent.el || inputEvent.priority === 'event') {
        return
      }

      // Hold back inputs inside the form, but not the form's own value —
      // el.contains(el) is true, and intercepting ourselves would freeze
      // the submit value forever.
      if (inputEvent.el !== el && el.contains(inputEvent.el)) {
        const name = inputEvent.inputType
          ? `${inputEvent.name}:${inputEvent.inputType}`
          : inputEvent.name

        inputValues.set(name, inputEvent.value)
        inputEvent.preventDefault()
      }
    })

    $el.on(
      'click.bsidesFormInputBinding',
      '.bsides-input-form-submit',
      (event) => {
        event.preventDefault()

        for (const [key, value] of inputValues.entries()) {
          Shiny?.setInputValue?.(key, value, { priority: 'event' })
        }

        $el.data('bsides-value', (event.currentTarget as HTMLButtonElement).value)
        callback(false)
      }
    )
  }

  override unsubscribe(el: HTMLElement): void {
    $(el).off('.bsidesFormInputBinding')
  }

  override receiveMessage(el: HTMLElement, data: FormReceiveMessageData): void {
    if (hasDefinedProperty(data, 'submit')) {
      $(el)
        .find(`.bsides-input-form-submit[value=${data.submit}]`)
        .trigger('click')
    }
  }
}

registerBinding(FormInputBinding, 'form')

export { FormInputBinding }
export type { FormReceiveMessageData }
