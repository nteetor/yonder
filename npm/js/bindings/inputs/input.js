import $ from 'jquery'

class InputBinding {
  static get prefix() {
    return 'bsides'
  }

  static get type() {
    throw 'not implemented'
  }

  static get namespace() {
    return `.${this.type}`
  }

  get events() {
    return []
  }

  constructor() {
    this.priority = 'deferred'
  }

  find(scope) {
    return $(scope).find(`.${this.constructor.prefix}-${this.constructor.type}`)
  }

  getId(element) {
    return element.id
  }

  getType(element) {
    return null
  }

  getValue(element) {
    throw 'not implemented'
  }

  subscribe(element, callback) {
    this.events.forEach((e) => {
      const event = `${e.type ? e.type : e}${this.constructor.namespace}`
      const selector = e.selector ? e.selector : (null)

      $(element).on(event, selector, (e) => {
        callback(this.priority)
      })
    })
  }

  unsubscribe(element) {
    $(element).off(this.namespace)
  }

  receiveMessage(element, data) {
    throw 'not implemented'
  }

  getState(element) {
    throw 'not implemented'
  }

  // @return { policy: RatePolicyModes, delay: number }
  getRatePolicy(element) {
    return null
    element // unused
  }

  initialize(element) {

  }

  dispose(element) {

  }
}

export default InputBinding
