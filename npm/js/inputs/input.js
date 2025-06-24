import $ from 'jquery'

class Input {
  static get type() {
    return `bsides.${this.name}`
  }

  static get namespace() {
    return `.${this.type}`
  }

  static get priority() {
    return 'deferred'
  }

  static get events() {
    return []
  }

  static find(scope) {
    return $(scope).find(`.bsides-${this.name}`)
  }

  static getId(element) {
    return element.id
  }

  static getType(element) {
    return null
  }

  static getValue(element) {
    throw 'not implemented'
  }

  static subscribe(element, callback) {
    this.events.forEach((event) => {
      $(element).on(`${event}${this.namespace}`, () => {
        callback(this.priority)
      })
    })
  }

  static unsubscribe(element) {
    $(element).off(this.namespace)
  }

  static receiveMessage(element, data) {
    throw 'not implemented'
  }

  static getState(element) {
    let input = InputStore.get(element, this.type)

    if (!input) {
      return
    }

    return { value: input.values() }
  }

  // @return { policy: RatePolicyModes, delay: number }
  static getRatePolicy(element) {
    return null
    element // unused
  }

  static initialize(element) {

  }

  static dispose(element) {

  }
}

export default Input
