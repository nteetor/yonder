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

  const inputStore = new Map();
  const InputStore = {
    set(element, key, instance) {
      if (!inputStore.has(element)) {
        inputStore.set(element, new Map());
      }
      const instanceStore = inputStore.get(element);
      if (!instanceStore.has(key) && instanceStore.size !== 0) {
        return;
      }
      instanceStore.set(key, instance);
    },
    get(element, key) {
      if (inputStore.has(element)) {
        return inputStore.get(element).get(key) || null;
      }
      return null;
    },
    remove(element, key) {
      if (!inputStore.has(element)) {
        return;
      }
      const store = inputStore.get(element);
      store.delete(key);
      if (store.size === 0) {
        inputStore.delete(element);
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
      InputStore.set(element, this.constructor.BINDING_KEY, this);
    }
    value(x) {
      return null;
    }
    content(x) {
      return null;
    }
    dispose() {
      this._callback = () => {};
      InputStore.remove(element, this.constructor.BINDING_KEY);
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
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        return null;
      }
      return input.value();
    }
    static subscribe(element, callback) {
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      input._callback = callback;
    }
    static unsubscribe(element) {
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      input.dispose();
    }
    static receiveMessage(element, data) {
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      for (const [method, args] of Object.entries(data)) {
        input[method](args);
      }
    }
    static getState(element) {
      let input = InputStore.get(element, this.BINDING_KEY);
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
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        return;
      }
      input.dispose();
    }
    static ShinyInterface() {
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
    content(x) {
      this._element.innerHTML = x;
      return this;
    }

    // this argument name is garbo
    disable(x) {
      if (x === true) {
        this._element.setAttribute('disabled', '');
      } else {
        this._element.removeAttribute('disabled');
      }
      return this;
    }
    static initialize(element) {
      let input = InputStore.get(element, this.BINDING_KEY);
      if (!input) {
        input = new ButtonInput(element);
      }
    }
  }
  $(document).on(ButtonInput.EVENTS, ButtonInput.SELECTOR, event => {
    let button = InputStore.get(event.currentTarget, ButtonInput.BINDING_KEY);
    if (!button) {
      return;
    }
    button.value(button.value() + 1);
  });
  if (Shiny) {
    Shiny.inputBindings.register(ButtonInput.ShinyInterface());
  }

  const bsides = {
    ButtonInput
  };

  return bsides;

}));
//# sourceMappingURL=bsides.js.map
