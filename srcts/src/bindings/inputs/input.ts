import $ from 'jquery'

import { pkg } from '../../utils'

type BindingEvent = string | { type: string; selector?: string }

interface RatePolicy {
  policy: 'debounce' | 'throttle'
  delay: number
}

type SubscribeCallback = (priority?: string) => void

class InputBinding {
  priority: string

  static get prefix(): string {
    return pkg.prefix
  }

  static get type(): string {
    throw new Error('not implemented')
  }

  static get namespace(): string {
    return `.${this.type}`
  }

  get events(): BindingEvent[] {
    return []
  }

  constructor() {
    this.priority = 'deferred'
  }

  // Typed access to static members overridden by subclasses.
  protected get ctor(): typeof InputBinding {
    return this.constructor as typeof InputBinding
  }

  find(scope: HTMLElement): JQuery {
    return $(scope).find(`.${this.ctor.prefix}-${this.ctor.type}`)
  }

  getId(element: HTMLElement): string {
    return element.id
  }

  getType(element: HTMLElement): string | null {
    void element
    return null
  }

  getValue(element: HTMLElement): unknown {
    void element
    throw new Error('not implemented')
  }

  subscribe(element: HTMLElement, callback: SubscribeCallback): void {
    for (const e of this.events) {
      const type = typeof e === 'string' ? e : e.type
      const selector = typeof e === 'string' ? null : e.selector ?? null
      const event = `${type}.${this.ctor.prefix}${this.ctor.namespace}`

      $(element).on(event, selector, () => {
        console.log(event)
        callback(this.priority)
      })
    }
  }

  unsubscribe(element: HTMLElement): void {
    $(element).off(`.${this.ctor.prefix}${this.ctor.namespace}`)
  }

  receiveMessage(element: HTMLElement, data: unknown): void {
    void element
    void data
    throw new Error('not implemented')
  }

  getState(element: HTMLElement): unknown {
    void element
    throw new Error('not implemented')
  }

  getRatePolicy(element: HTMLElement): RatePolicy | null {
    void element
    return null
  }

  initialize(element: HTMLElement): void {
    void element
  }

  dispose(element: HTMLElement): void {
    void element
  }
}

export default InputBinding
export type { BindingEvent, RatePolicy, SubscribeCallback }
