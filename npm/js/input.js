import $ from 'jquery'

import InputStore from './input-store.js'

class Input {
  // getters

  static get BINDING_KEY() {
    return `bsides.${this.NAME}`
  }

  static get EVENT_KEY() {
    return `.${this.BINDING_KEY}`
  }

  static get EVENTS() {
    return null
  }

  static get SELECTOR() {
    return `.bsides-${this.NAME}`
  }

  // public

  constructor(element) {
    this._element = element
    this._value = null
    this._debounce = false
    this._callback = (debounce) => {}

    InputStore.set(element, this.constructor.BINDING_KEY, this)
  }

  value(x) {
    return null
  }

  content(x) {
    return null
  }

  dispose() {
    this._callback = () => {}
    InputStore.remove(element, this.constructor.BINDING_KEY)
  }

  // static

  static find(scope) {
    return $(scope).find(this.SELECTOR)
  }

  static getId(element) {
    return element.id
  }

  static getType(element) {
    return null
    element // unused
  }

  static getValue(element) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return null
    }

    return input.value()
  }

  static subscribe(element, callback) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    input._callback = callback
  }

  static unsubscribe(element) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    input.dispose()
  }

  static receiveMessage(element, data) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    for (const [method, args] of Object.entries(data)) {
      input[method](args)
    }
  }

  static getState(element) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    return { value: input.value() }
  }

  // @return { policy: RatePolicyModes, delay: number }
  static getRatePolicy(element) {
    return null
    element // unused
  }

  static initialize(element) {
    element // unused
  }

  static dispose(element) {
    let input = InputStore.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    input.dispose()
  }

  static ShinyInterface() {
    return this
  }
}

export default Input
