import $ from 'jquery'

import InputStore from '../utils/input-store.js'

class Input {
  static get type() {
    return `bsides.${this.name}`
  }

  static get namespace() {
    return `.${this.type}`
  }

  static get events() {
    return null
  }

  static get selector() {
    return `.bsides-${this.name}`
  }

  #value = null
  #debounce = false
  #callback = (debounce) => {}
  #element = null

  constructor(element) {
    this.#element = element

    InputStore.set(element, this.constructor.type, this)
  }

  get value() {
    return this.#value
  }

  set value(x) {
    this.#value = x
    this.#callback(this.#debounce)
  }

  // garbo arg name
  set label(x) {
    throw "not implemented"
  }

  get label() {
    return null
  }

  get callback() {
    return this.#callback
  }

  set callback(f) {
    this.#callback = f
  }

  get element() {
    return this.#element
  }

  dispose() {
    this.#callback = (debounce) => {}
    this.#value = null
    InputStore.remove(element, this.constructor.type)
  }

  // static

  static find(scope) {
    return $(scope).find(this.selector)
  }

  static getId(element) {
    return element.id
  }

  static getType(element) {
    return null
    element // unused
  }

  static getValue(element) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return null
    }

    return input.value
  }

  static subscribe(element, callback) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return
    }

    input.callback = callback
  }

  static unsubscribe(element) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return
    }

    input.dispose()
  }

  static receiveMessage(element, data) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return
    }

    for (const [key, value] of Object.entries(data)) {
      if (key === 'value') {
        // nothing confusing here
        input.value = value
      } else if (key === 'label') {
        input.label = value
      } else if (key === 'disable') {
        input.disable(value)
      }
    }
  }

  static getState(element) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return
    }

    return { value: input.value }
  }

  // @return { policy: RatePolicyModes, delay: number }
  static getRatePolicy(element) {
    return null
    element // unused
  }

  static initialize(element) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      input = new this(element)
    }
  }

  static dispose(element) {
    let input = InputStore.get(element, this.type)

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
