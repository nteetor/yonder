/*!
  * bsides v0.2.0.9000 (https://nteetor.github.com/yonder)
  * Copyright 2011-2025 Nathan Teetor <nate@haufin.ch>
  * Licensed under MIT (https://github.com/nteetor/yonder/blob/main/LICENSE.note)
  */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('jquery')) :
  typeof define === 'function' && define.amd ? define(['jquery'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.bsides = factory(global.$));
})(this, (function ($) { 'use strict';

  const boundInputs = new Map();
  const BoundInputs = {
    set(element, key, instance) {
      if (!boundInputs.has(element)) {
        boundInputs.set(element, new Map());
      }
      const store = boundInputs.get(element);
      if (!store.has(key) && store.size !== 0) {
        return;
      }
      store.set(key, instance);
      console.log(boundInputs);
    },
    get(element, key) {
      if (boundInputs.has(element)) {
        return boundInputs.get(element).get(key) || null;
      }
      return null;
    },
    remove(element, key) {
      if (!boundInputs.has(element)) {
        return;
      }
      const store = boundInputs.get(element);
      store.delete(key);
      if (store.size === 0) {
        boundInputs.delete(element);
      }
    }
  };

  class Input {
    // getters

    static get BINDING_KEY() {
      return `bsides.${this.NAME}`;
    }
    static get EVENT_KEY() {
      return `.${this.BINDING_KEY}`;
    }
    static get EVENTS() {
      return null;
    }
    static get SELECTOR() {
      return `.bsides-${this.NAME}`;
    }

    // public

    constructor(element) {
      this._element = element;
      this._value = null;
      this._debounce = false;
      this._callback = debounce => {};
      BoundInputs.set(element, this.constructor.BINDING_KEY, this);
    }
    value(x) {
      return null;
    }
    content(x) {
      return null;
    }
    dispose() {
      this._callback = () => {};
      BoundInputs.remove(element, this.constructor.BINDING_KEY);
    }

    // static

    static find(scope) {
      return $(scope).find(this.SELECTOR);
    }
    static getId(element) {
      return element.id;
    }
    static getType(element) {
      return null;
    }
    static getValue(element) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return null;
      }
      return input.value();
    }
    static subscribe(element, callback) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      console.log(input);
      input._callback = callback;
      console.log(input._callback);
    }
    static unsubscribe(element) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      input.dispose();
    }
    static receiveMessage(element, data) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      data.forEach(msg => {
        let [method, args = []] = msg;
        input[method](...args);
      });
    }
    static getState(element) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      return {
        value: input.value()
      };
    }

    // @return { policy: RatePolicyModes, delay: number }
    static getRatePolicy(element) {
      return null;
    }
    static initialize(element) {
    }
    static dispose(element) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      input.dispose();
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
      return this;
    }
  }

  class ButtonInput extends Input {
    static get NAME() {
      return 'button';
    }
    static get EVENTS() {
      return `click${this.EVENT_KEY}`;
    }
    constructor(element) {
      super(element);
      this._value = 0;
    }
    value(x) {
      if (typeof x === 'undefined') {
        return this._value;
      }
      this._value = x;
      this._callback(this._debounce);
      return this;
    }
    content(text) {
      this._element.innerHTML = text;
      return this;
    }
    static initialize(element) {
      let input = BoundInputs.get(element, this.BINDING_KEY);
      if (!input) {
        input = new ButtonInput(element);
      }
    }
    static subscribe(element, callback) {
      $(element).on("click", event => {
        callback();
      });
    }
  }
  $(document).on(ButtonInput.EVENTS, ButtonInput.SELECTOR, event => {
    let button = BoundInputs.get(event.currentTarget, ButtonInput.BINDING_KEY);
    if (!button) {
      return;
    }
    button.value(button.value() + 1);
  });
  if (Shiny) {
    Shiny.inputBindings.register(ButtonInput.ShinyInterface());
  }

  const bsides = {
    Input,
    ButtonInput
  };

  return bsides;

}));
//# sourceMappingURL=bsides.js.map
