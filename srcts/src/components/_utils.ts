// Modeled on bslib's srcts/src/components/_utils.ts.

import type { InputBinding as InputBindingType } from 'rstudio-shiny/srcts/types/src/bindings/input'
import type { ShinyClass } from 'rstudio-shiny/srcts/types/src'

const Shiny: ShinyClass | undefined = window.Shiny

// Exclude undefined from T
type NotUndefined<T> = T extends undefined ? never : T

// Shiny's own InputBinding class, so bindings inherit the real contract
// (including methods added in future Shiny versions). The fallback keeps this
// module loadable outside a Shiny app; registerBinding() no-ops there anyway.
const InputBinding = (
  Shiny ? Shiny.InputBinding : class {}
) as typeof InputBindingType

function registerBinding(
  inputBindingClass: new () => InputBindingType,
  name: string
): void {
  if (Shiny) {
    Shiny.inputBindings.register(new inputBindingClass(), 'bsides.' + name)
  }
}

// Base class for bindings that use native DOM events instead of jQuery.
// jQuery bindings clean up by event namespace; native listeners have no
// namespaces, so each binding instance keeps a per-element AbortController:
// listen() registers listeners under the element's signal and unsubscribe()
// aborts it, detaching them all at once. The controller map is an instance
// field, so every binding owns its listeners independently.
abstract class NativeEventInputBinding extends InputBinding {
  #controllers = new WeakMap<HTMLElement, AbortController>()

  protected listen(
    el: HTMLElement,
    type: string,
    handler: (event: Event) => void
  ): void {
    let controller = this.#controllers.get(el)

    if (!controller) {
      controller = new AbortController()
      this.#controllers.set(el, controller)
    }

    el.addEventListener(type, handler, { signal: controller.signal })
  }

  override unsubscribe(el: HTMLElement): void {
    this.#controllers.get(el)?.abort()
    this.#controllers.delete(el)
  }
}

// Handlers for messages sent from the R side via
// session$sendCustomMessage("bsides:<type>", ...).
function addCustomMessageHandler(
  type: string,
  handler: (data: any) => void | Promise<void>
): void {
  if (Shiny) {
    Shiny.addCustomMessageHandler('bsides:' + type, handler)
  }
}

// Return true if the key exists on the object and the value is not undefined.
//
// This method is mainly used in input bindings' `receiveMessage` method.
// Since we know that the values are sent by Shiny via `{jsonlite}`,
// then we know that there are no `undefined` values. `null` is possible, but
// not `undefined`.
function hasDefinedProperty<
  Prop extends keyof X,
  X extends { [key: string]: any }
>(
  obj: X,
  prop: Prop
): obj is X & { [key in NonNullable<Prop>]: NotUndefined<X[key]> } {
  return (
    Object.prototype.hasOwnProperty.call(obj, prop) && obj[prop] !== undefined
  )
}

export {
  InputBinding,
  NativeEventInputBinding,
  registerBinding,
  addCustomMessageHandler,
  hasDefinedProperty,
  Shiny
}
