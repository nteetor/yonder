const VERSION = "0.1.0";

class Input {
  constructor(element) {
    this._element = element;
  }

  // getters

  static get VERSION() {
    return VERSION;
  }

  static get TYPE() {
    return null;
  }

  // public

  static find(scope) {
    throw "not implemented";
  }

  static getId(el) {
    return el.id;
  }

  static getType(el) {
    return this.TYPE;
  }

  static getValue(el) {
    throw "not implemented";
  }

  static subscribe(el, callback) {

  }

  static unsubscribe() {

  }

  static receiveMessage(el, msg) {
    if (typeof msg.type === "undefined") {
      throw "missing message type";
    }
  }

  static getState(el, data) {
    throw "not implemented";
  }

  static getRatePolicy() {
    return null;
  }

  static dispose() {

  }
}

export default Input;
