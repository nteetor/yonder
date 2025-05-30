import $ from 'jquery'
import BoundInputs from './bound-inputs.js'

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

    BoundInputs.set(element, this.constructor.BINDING_KEY, this)
  }

  value(x) {
    return null
  }

  content(x) {
    return null
  }

  dispose() {
    this._callback = () => {}
    BoundInputs.remove(element, this.constructor.BINDING_KEY)
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
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      return null
    }

    return input.value()
  }

  static subscribe(element, callback) {
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    console.log(input)

    input._callback = callback

    console.log(input._callback)
  }

  static unsubscribe(element) {
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    input.dispose()
  }

  static receiveMessage(element, data) {
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    data.forEach((msg) => {
      let [method, args = []] = msg

      input[method](...args)
    })
  }

  static getState(element) {
    let input = BoundInputs.get(element, this.BINDING_KEY)

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
    let input = BoundInputs.get(element, this.BINDING_KEY)

    if (!input) {
      return
    }

    input.dispose()
  }

  static ShinyInterface() {
    /*return {
      find: this.find,
      getId: this.getId,
      getType: this.getType,
      getValue: this.getValue,
      subscribe: this.subscribe,
      unsubscribe: this.unsubscribe,
      receiveMessage: this.receiveMessage,
      getState: this.getState,
      getRatePolicy: this.getRatePolicy,
      initialize: this.initialize,
      dispose: this.dispose
    }*/
    return this
  }
}

export default Input
