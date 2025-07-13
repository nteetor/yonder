/*!
  * bsides v0.2.0.9000 (https://nteetor.github.com/yonder)
  * Copyright 2011-2025 Nathan Teetor <nate@haufin.ch>
  * Licensed under MIT (https://github.com/nteetor/yonder/blob/main/LICENSE.note)
  */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(require('jquery'), require('Shiny')) :
  typeof define === 'function' && define.amd ? define(['jquery', 'Shiny'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.$, global.Shiny));
})(this, (function ($, Shiny$1) { 'use strict';

  const pkg = {
    prefix: 'bsides'
  };
  function addCustomMessageHandler(type, handler) {
    if (window.Shiny) {
      Shiny.addCustomMessageHandler(`${pkg.prefix}:${type}`, handler);
    }
  }
  function initialize(callback) {
    if (document.readyState === 'complete') {
      callback();
    } else {
      document.addEventListener('DOMContentLoaded', callback);
    }
  }
  function registerBinding(binding) {
    if (window.Shiny) {
      Shiny.inputBindings.register(new binding(), `${pkg.prefix}.${binding.type}`);
    }
  }

  class InputBinding {
    static get prefix() {
      return pkg.prefix;
    }
    static get type() {
      throw 'not implemented';
    }
    static get namespace() {
      return `.${this.type}`;
    }
    get events() {
      return [];
    }
    constructor() {
      this.priority = 'deferred';
    }
    find(scope) {
      return $(scope).find(`.${this.constructor.prefix}-${this.constructor.type}`);
    }
    getId(element) {
      return element.id;
    }
    getType(element) {
      return null;
    }
    getValue(element) {
      throw 'not implemented';
    }
    subscribe(element, callback) {
      this.events.forEach(e => {
        const event = `${e.type ? e.type : e}${this.constructor.namespace}`;
        const selector = e.selector ? e.selector : null;
        console.log(`${event}, ${selector}, ${this.priority}`);
        $(element).on(event, selector, e => {
          callback(this.priority);
        });
      });
    }
    unsubscribe(element) {
      $(element).off(this.namespace);
    }
    receiveMessage(element, data) {
      throw 'not implemented';
    }
    getState(element) {
      throw 'not implemented';
    }

    // @return { policy: RatePolicyModes, delay: number }
    getRatePolicy(element) {
      return null;
    }
    initialize(element) {}
    dispose(element) {}
  }

  class ButtonInputBinding extends InputBinding {
    static get type() {
      return 'button';
    }
    get events() {
      return ['click'];
    }
    get data() {
      return {
        clicks: `${this.constructor.prefix}-clicks`
      };
    }
    initialize(element) {
      const $element = $(element);
      $element.data(this.data.clicks, 0);
      $element.on(`click${this.constructor.namespace}`, event => {
        const clicks = +$element.data(this.data.clicks);
        $element.data(this.data.clicks, clicks + 1);
      });
    }
    getType(element) {
      return `${this.constructor.prefix}${this.constructor.namespace}`;
    }
    getValue(element) {
      return $(element).data(this.data.clicks);
    }
    receiveMessage(element, data) {}
  }

  class CheckboxInputBinding extends InputBinding {
    static get type() {
      return 'checkbox';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        label: '.form-check-label',
        value: '.form-check-input'
      };
    }
    getValue(element) {
      return $(element).children(this.selectors.value).prop('checked');
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $label = $element.find(this.selectors.label);
      const $value = $element.find(this.selectors.value);
      if (data.hasOwnProperty('choice')) {
        $label.html(data.choice);
      }
      if (data.hasOwnProperty('value')) {
        $value.prop('checked', data.value);
      }
      if (data.hasOwnProperty('disable')) {
        $value.prop('disabled', data.disable);
      }
      $element.trigger('change');
    }
  }

  class CheckboxGroupInputBinding extends InputBinding {
    static get type() {
      return 'checkboxgroup';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        choice: '.form-check-label,.btn',
        value: '.form-check-input,.btn-check'
      };
    }
    getType(element) {
      return `${this.constructor.prefix}${this.constructor.namespace}`;
    }
    getValue(element) {
      return $(element).find(this.selectors.value).filter(':checked').map((i, el) => el.value).get();
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $values = $element.find(this.selectors.value);
      if (data.hasOwnProperty('options')) {
        $element.find('.form-check').remove();
        $element.html(data.options);
      }
      if (data.hasOwnProperty('select')) {
        $values.prop('checked', false);
        $values.filter((i, e) => data.select.includes(e.value)).prop('checked', true);
      }
      if (data.hasOwnProperty('disable')) {
        $values.prop('disabled', false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop('disabled', true);
      }
      $element.trigger('change');
    }
  }

  class FormInputBinding extends InputBinding {
    static get type() {
      return 'form';
    }
    get events() {
      return [{
        event: 'click',
        selector: this.selectors.submit
      }];
    }
    get selectors() {
      return {
        submit: '.bsides-btn-submit'
      };
    }
    get data() {
      return {
        value: `${this.constructor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = $(element);
      let inputValues = new Map();
      $element.on(`shiny:inputchanged${this.constructor.namespace}`, event => {
        if (!event.el || event.priority === 'event') {
          return;
        }
        if (element.contains(event.el)) {
          const name = event.inputType ? `${event.name}:${event.inputType}` : event.name;
          inputValues.set(name, event.value);
          event.preventDefault();
        }
      });
      $element.on(`click${this.constructor.namespace}`, this.selectors.submit, event => {
        event.preventDefault();
        for (const [key, value] of inputValues.entries()) {
          Shiny.setInputValue(key, value, {
            priority: 'event'
          });
        }
        const value = event.currentTarget.value;
        $element.data(this.data.value, value);
      });
    }
    getValue(element) {
      return $(element).data(this.data.value);
    }
    receiveMessage(element, data) {
      const $element = $(element);
      if (data.hasOwnProperty('submit')) {
        const value = data.submit;
        $element.find(`${this.selectors.submit}[value=${value}]`).trigger('click');
      }
    }
  }

  class LinkInputBinding extends InputBinding {
    static get type() {
      return 'link';
    }
    get events() {
      return ['click'];
    }
    get data() {
      return {
        clicks: `${this.constructor.prefix}-clicks`
      };
    }
    initialize(element) {
      const $element = $(element);
      $element.data(this.data.clicks, 0);
      $element.on(`click${this.constructor.namespace}`, event => {
        const clicks = +$element.data(this.data.clicks);
        $element.data(this.data.clicks, clicks + 1);
      });
    }
    getType(element) {
      return `${this.constructor.prefix}${this.constructor.namespace}`;
    }
    getValue(element) {
      return $(element).data(this.data.clicks);
    }
  }

  class ListGroupInputBinding extends InputBinding {
    static get type() {
      return 'listgroup';
    }
    get events() {
      return ['click'];
    }
    get selectors() {
      return {
        choice: '.list-group-item-action',
        value: '.list-group-item-action'
      };
    }
    get data() {
      return {
        value: `${this.constructor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = $(element);
      $element.on('click', this.selectors.choice, event => {
        const $choice = $(event.currentTarget);
        $choice.toggleClass('active');
      });
    }
    getValue(element) {
      return $(element).find(`${this.selectors.value}.active`).map((i, el) => el.getAttribute(`data-${this.data.value}`)).get();
    }
  }

  class MenuInputBinding extends InputBinding {
    static get type() {
      return 'menu';
    }
    get events() {
      return [{
        type: 'click',
        selector: this.selectors.choice
      }];
    }
    get selectors() {
      return {
        choice: '.dropdown-item',
        value: '.dropdown-item'
      };
    }
    get data() {
      return {
        value: `${this.constructor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = $(element);
      $element.on('click', this.selectors.value, event => {
        $element.data(this.data.value, event.currentTarget.value);
      });
    }
    getValue(element) {
      return $(element).data(this.data.value);
    }
  }

  class RadioGroupInputBinding extends InputBinding {
    static get type() {
      return 'radiogroup';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        choice: '.form-check-label,.btn',
        value: '.form-check-input,.btn-check'
      };
    }

    /*getType(element) {
      return `${this.constructor.prefix}${this.constructor.namespace}`
    }*/

    getValue(element) {
      return $(element).find(this.selectors.value).filter(':checked').val();
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $values = $element.find(this.selectors.value);
      if (data.hasOwnProperty('options')) {
        $element.find('.form-check').remove();
        $element.html(data.options);
      }
      if (data.hasOwnProperty('select')) {
        $values.prop('checked', false);
        $values.filter((i, e) => data.select.includes(e.value)).prop('checked', true);
      }
      if (data.hasOwnProperty('disable')) {
        $values.prop('disabled', false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop('disabled', true);
      }
      $element.trigger('change');
    }
  }

  class RangeInputBinding extends InputBinding {
    static get type() {
      return 'range';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        value: '.form-range'
      };
    }
    getValue(element) {
      return +$(element).find(this.selectors.value).val();
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $value = $element.find(this.selectors.value);
      if (data.hasOwnProperty('value')) {
        $value.val(data.value);
      }
      if (data.hasOwnProperty('disable')) {
        $value.prop('disable', data.disable);
      }
      $element.trigger('change');
    }
  }

  class SelectInputBinding extends InputBinding {
    static get type() {
      return 'select';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        value: 'option'
      };
    }
    getValue(element) {
      return element.value;
    }
    receiveMessage(element, data) {
      const $element = $(element);
      console.log(data);
      if (data.hasOwnProperty('options')) {
        $element.find(this.selectors.value).remove();
        $element.html(data.options);
      }
      if (data.hasOwnProperty('select')) {
        $element.val(data.select);
      }
      if (data.hasOwnProperty('disable')) {
        console.log('disable');
        const $values = $element.find('option');
        $values.prop('disabled', false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop('disabled', true);
      }
      $element.trigger('change');
    }
  }

  class TextInputBinding extends InputBinding {
    static get type() {
      return 'text';
    }
    get events() {
      return ['keyup', 'input', 'change'];
    }
    get selectors() {
      return {
        value: 'input'
      };
    }
    getValue(element) {
      return element.value;
    }
    getRatePolicy(element) {
      return {
        policy: 'debounce',
        delay: 250
      };
    }
    receiveMessage(element, data) {
      const $element = $(element);
      if (data.hasOwnProperty('value')) {
        $element.val(data.value);
      }
      if (data.hasOwnProperty('disable')) {
        $element.prop('disabled', data.disable);
      }
      $element.trigger('change');
    }
  }

  class TextGroupInputBinding extends InputBinding {
    static get type() {
      return 'textgroup';
    }
    get events() {
      return ['keyup', 'input', 'change'];
    }
    get selectors() {
      return {
        value: 'input',
        text: '.input-group-text'
      };
    }
    getValue(element) {
      const $element = $(element);
      if (!$element.find(this.selectors.value).val()) {
        return null;
      }
      return $element.find(`${this.selectors.text},${this.selectors.value}`).map((i, e) => e.innerText || e.value || '').get().join('');
    }
    getRatePolicy(element) {
      return {
        policy: 'debounce',
        delay: 250
      };
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $value = $(element).find(this.selectors.value);
      if (data.hasOwnProperty('value')) {
        $value.val(data.value);
      }
      if (data.hasOwnProperty('disable')) {
        $value.prop('disabled', data.disable);
      }
      $element.trigger('change');
    }
  }

  function registerInputs() {
    registerBinding(ButtonInputBinding);
    registerBinding(CheckboxInputBinding);
    registerBinding(CheckboxGroupInputBinding);
    registerBinding(FormInputBinding);
    registerBinding(LinkInputBinding);
    registerBinding(ListGroupInputBinding);
    registerBinding(MenuInputBinding);
    registerBinding(RadioGroupInputBinding);
    registerBinding(RangeInputBinding);
    registerBinding(SelectInputBinding);
    registerBinding(TextInputBinding);
    registerBinding(TextGroupInputBinding);
  }

  class Toast extends bootstrap.Toast {
    constructor(toast) {
      super(toast, {
        autoHide: false
      });
    }
    get state() {
      return this.isShown() ? 'shown' : 'hidden';
    }
    static addMessageHandlers() {
      addCustomMessageHandler('toastAdd', async function (data) {
        if (!data.target) {
          return;
        }
        const container = document.getElementById(data.target);
        if (!container) {
          return;
        }
        await Shiny$1.renderContentAsync(container, data.toast, 'beforeend');
      });
    }
  }
  class ToastInputBinding extends InputBinding {
    static get type() {
      return 'toast';
    }
    get events() {
      return ['shown.bs.toast', 'hidden.bs.toast'];
    }
    initialize(element) {
      new Toast(element);
    }
    getValue(element) {
      const toast = Toast.getInstance(element);
      if (!toast) {
        return;
      }
      return toast.state;
    }
    receiveMessage(element, data) {
      const toast = Toast.getInstance(element);
      if (!toast) {
        return;
      }
      if (data.method === 'show') {
        toast.show();
      } else if (data.method === 'hide') {
        toast.hide();
      }
    }
  }
  Shiny.addCustomMessageHandler("yonder:toast", msg => {
    let _show = function (data) {
      document.querySelector(".yonder-toasts").insertAdjacentHTML("beforeend", data.content);
      $(".yonder-toasts > .toast:last-child").toast("show");
    };
    let _close = function (data) {
      let toasts = document.querySelectorAll(".yonder-toasts .toast");
      if (toasts.length) {
        $(toasts).toast("hide");
      }
    };
    if (!msg.type) {
      return;
    }
    if (msg.type === "show") {
      _show(msg.data);
    } else if (msg.type === "close") {
      _close(msg.data);
    } else {
      console.warn(`no toast ${msg.type} method`);
    }
  });
  Toast.addMessageHandlers();
  registerBinding(ToastInputBinding);

  initialize(() => {
    registerInputs();
  });

}));
//# sourceMappingURL=bsides.js.map
