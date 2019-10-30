import InputError from "../errors/input.js"
import Store from "../data/store.js"

const VERSION = "0.1.2"

class Input {

  // getters ----

  static get VERSION() {
    return VERSION
  }

  // methods ----

  constructor(element, type, self) {
    if ((typeof element === "object" && element.nodeType !== 1) &&
        (typeof element !== "string")) {
      throw new InputError("Invalid Argument", "`element` must be a node or string")
    }

    if (typeof element === "string") {
      element = document.querySelector(element)

      if (!element) {
        throw new InputError("Element Not Found", "could not find element for given `element` selector")
      }
    }

    this._element = element
    this._type = type
    this._value = null
    this._callback = () => {}

    Store.setData(element, type, this)
  }

  content(html) {
    this._element.innerHTML = html
  }

  dispose() {
    Store.removeData(this._element, this._type)
    this._element = null
  }

  // public ----

  static initialize(element, type, impl) {
    let input = Store.getData(element, type)

    if (!input) {
      input = new impl(element)
    }
  }

  static find(scope, selector) {
    return scope.querySelectorAll(selector)
  }

  static getId(element) {
    return element.id
  }

  static getType(element) {
    return null
  }

  static getValue(element, type) {
    let input = Store.getData(element, type)

    if (!input) {
      return null
    }

    return input.value()
  }

  static subscribe(element, callback, type) {
    let input = Store.getData(element, type)

    if (!input) {
      return
    }

    input._callback = callback
  }

  static unsubscribe(element, type) {
    let input = Store.getData(element, type)

    if (!input) {
      return
    }

    input._callback = () => {}
    Store.removeData(element, type)
  }

  static receiveMessage(element, message, type) {
    let input = Store.getData(element, type)

    if (!input) {
      return
    }

    message.forEach((msg) => {
      let [method, args] = msg

      if (!args) {
        input[method]()
      } else {
        input[method](...args)
      }
    })
  }

  static getState(element, data) {
    throw new InputError("Method Not Implemented")
  }

  static getRatePolicy() {
    return null
  }
}

export default Input
