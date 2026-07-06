import $ from 'jquery'

import InputBinding from './input'
import type { BindingEvent } from './input'

interface FormMessage {
  submit?: string
}

class FormInputBinding extends InputBinding {
  static override get type(): string {
    return 'form'
  }

  override get events(): BindingEvent[] {
    return [
      { type: 'click', selector: this.selectors.submit }
    ]
  }

  get selectors(): { submit: string } {
    return {
      submit: '.bsides-btn-submit'
    }
  }

  get data(): { value: string } {
    return {
      value: `${this.ctor.prefix}-value`
    }
  }

  override initialize(element: HTMLElement): void {
    const $element = $(element)

    const inputValues = new Map<string, unknown>()

    $element.on(
      `shiny:inputchanged${this.ctor.namespace}`,
      (event) => {
        const inputEvent = event as unknown as ShinyInputChangedEvent

        if (!inputEvent.el || inputEvent.priority === 'event') {
          return
        }

        if (element.contains(inputEvent.el)) {
          const name = inputEvent.inputType
            ? `${inputEvent.name}:${inputEvent.inputType}`
            : inputEvent.name

          inputValues.set(name, inputEvent.value)
          inputEvent.preventDefault()
        }
      }
    )

    $element.on(
      `click${this.ctor.namespace}`,
      this.selectors.submit,
      (event) => {
        event.preventDefault()

        for (const [key, value] of inputValues.entries()) {
          window.Shiny?.setInputValue(key, value, { priority: 'event' })
        }

        const value = (event.currentTarget as HTMLButtonElement).value

        $element.data(this.data.value, value)
      }
    )
  }

  override getValue(element: HTMLElement): unknown {
    return $(element).data(this.data.value)
  }

  override receiveMessage(element: HTMLElement, data: FormMessage): void {
    const $element = $(element)

    if (Object.hasOwn(data, 'submit')) {
      const value = data.submit

      $element
        .find(`${this.selectors.submit}[value=${value}]`)
        .trigger('click')
    }
  }
}

export default FormInputBinding
