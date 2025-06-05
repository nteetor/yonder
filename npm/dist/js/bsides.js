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
    static get type() {
      return `bsides.${this.name}`;
    }
    static get namespace() {
      return `.${this.type}`;
    }
    static get events() {
      return null;
    }
    static get selector() {
      return `.bsides-${this.name}`;
    }
    #value = null;
    #debounce = false;
    #callback = debounce => {};
    #element = null;
    constructor(element) {
      this.#element = element;
      InputStore.set(element, this.constructor.type, this);
    }
    get value() {
      return this.#value;
    }
    set value(x) {
      this.#value = x;
      this.#callback(this.#debounce);
    }

    // garbo arg name
    set label(x) {
      throw "not implemented";
    }
    get label() {
      return null;
    }
    get callback() {
      return this.#callback;
    }
    set callback(f) {
      this.#callback = f;
    }
    get element() {
      return this.#element;
    }
    dispose() {
      this.#callback = debounce => {};
      this.#value = null;
      InputStore.remove(element, this.constructor.type);
    }

    // static

    static find(scope) {
      return $(scope).find(this.selector);
    }
    static getId(element) {
      return element.id;
    }
    static getType(element) {
      return null;
    }
    static getValue(element) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return null;
      }
      return input.value;
    }
    static subscribe(element, callback) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return;
      }
      input.callback = callback;
    }
    static unsubscribe(element) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return;
      }
      input.dispose();
    }
    static receiveMessage(element, data) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return;
      }
      for (const [key, value] of Object.entries(data)) {
        if (key === 'value') {
          // nothing confusing here
          input.value = value;
        } else if (key === 'label') {
          input.label = value;
        } else if (key === 'disable') {
          input.disable(value);
        }
      }
    }
    static getState(element) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return;
      }
      return {
        value: input.value
      };
    }

    // @return { policy: RatePolicyModes, delay: number }
    static getRatePolicy(element) {
      return null;
    }
    static initialize(element) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        input = new this(element);
      }
    }
    static dispose(element) {
      let input = InputStore.get(element, this.type);
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
    static get name() {
      return 'button';
    }
    static get events() {
      return `click${this.namespace}`;
    }
    constructor(element) {
      super(element);
      this.value = 0;
    }
    set label(x) {
      this.element.innerHTML = x;
    }
    get label() {
      this.element.innerHTML;
    }

    // this argument name is garbo
    disable(x) {
      if (x === true) {
        this.element.setAttribute('disabled', '');
      } else {
        this.element.removeAttribute('disabled');
      }
      return this;
    }
  }
  $(document).on(ButtonInput.events, ButtonInput.selector, event => {
    let button = InputStore.get(event.currentTarget, ButtonInput.type);
    if (!button) {
      return;
    }
    button.value++;
  });
  if (Shiny) {
    Shiny.inputBindings.register(ButtonInput.ShinyInterface());
  }

  class CheckboxInput extends Input {
    static get name() {
      return 'checkbox';
    }
    static get events() {
      return `change${this.namespace}`;
    }
    constructor(element) {
      super(element);
      let entries = $(element).find('input').toArray().map(element => {
        return {
          [element.value]: element.checked
        };
      });
      this.value = Object.assign(...entries);
    }
    setValue(key, x) {
      this.value[key] = x;
      this.callback();
      return this;
    }
    static getType(element) {
      return this.type;
    }
  }
  $(document).on(CheckboxInput.events, CheckboxInput.selector, event => {
    let checkbox = InputStore.get(event.currentTarget, CheckboxInput.type);
    if (!checkbox) {
      return;
    }
    let text = event.target.nextElementSibling.innerText;
    let checked = event.target.checked;
    checkbox.setValue(text, checked);
    console.log(checkbox.value);
  });
  if (Shiny) {
    Shiny.inputBindings.register(CheckboxInput.ShinyInterface());
  }

  class LinkInput extends Input {
    static get name() {
      return 'link';
    }
    static get events() {
      return `click.${this.namespace}`;
    }
    constructor(element) {
      super(element);
      this.value = 0;
    }
    set label(x) {
      this.element.innerHTML = x;
    }
    get label() {
      this.element.innerHTML;
    }
    disable(x) {
      if (x === "true") {
        this.element.setAttribute("disabled", "");
      } else {
        this.element.removeAttribute("disabled");
      }
    }
  }
  $(document).on(LinkInput.events, LinkInput.selector, event => {
    let link = InputStore.get(event.currentTarget, LinkInput.type);
    if (!link) {
      return;
    }
    event.preventDefault();
    link.value++;
  });
  if (Shiny) {
    Shiny.inputBindings.register(LinkInput.ShinyInterface());
  }

  const bsides = {
    ButtonInput,
    CheckboxInput,
    LinkInput
  };

  return bsides;

}));
//# sourceMappingURL=bsides.js.map
