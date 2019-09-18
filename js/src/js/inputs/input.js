import InputError from "../errors/input.js";
import Store from "../data/store.js";

const VERSION = "0.1.2";

class Input {
  constructor(element, type, self) {
    if (typeof element !== "object" &&
        element.nodeType !== 1) {
      throw new InputError("Invalid Argument", "`element` must be an element");
    }

    this._element = element;
    this._type = type;
    this._value = null;
    this._callback = () => {};
  }

  // getters ----

  static get VERSION() {
    return VERSION;
  }

  // methods ----

  content(html) {
    this._element.innerHTML = html;
  }

  dispose() {
    Store.removeData(this._element, this._type);
    this._element = null;
  }

  // public ----

  static initialize(element, type, input) {
    let data = Store.getData(element, type);

    if (!data) {
      data = new input(element);
    }
  }

  static find(scope, selector) {
    return scope.querySelectorAll(selector);
  }

  static getId(element) {
    return element.id;
  }

  static getType(element) {
    return null;
  }

  static getValue(element) {
    throw new InputError("Unimplemented Method");
  }

  static subscribe(element, callback, type) {
    let input = Store.getData(element, type);

    if (!input) {
      return;
    }

    input._callback = callback;
  }

  static unsubscribe(element, type) {
    let input = Store.getData(element, type);

    if (!input) {
      return;
    }

    input._callback = () => {};
  }

  static receiveMessage(element, message, type) {
    let input = Store.getData(element, type);

    if (!input) {
      return;
    }

    message.forEach((msg) => {
      console.log(msg);

      let [method, args] = msg;

      if (args === null) {
        return;
      }

      input[method](args);
    });
  }

  static getState(element, data) {
    throw "not implemented";
  }

  static getRatePolicy() {
    return null;
  }
}

export default Input;
