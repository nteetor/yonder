/*!
  * bsides v0.2.0.9000 (https://nteetor.github.com/yonder)
  * Copyright 2011-2025 Nathan Teetor <nate@haufin.ch>
  * Licensed under MIT (https://github.com/nteetor/yonder/blob/main/LICENSE.note)
  */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(require('jquery')) :
  typeof define === 'function' && define.amd ? define(['jquery'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.$));
})(this, (function ($) { 'use strict';

  class InputBinding {
    static get prefix() {
      return 'bsides';
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
      this.events.forEach(event => {
        $(element).on(`${event}${this.constructor.namespace}`, () => {
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

  class CheckboxInputBinding extends InputBinding {
    static get type() {
      return 'checkbox';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        choice: '.form-check-label',
        value: '.form-check-input'
      };
    }
    getType(element) {
      console.log(this.constructor);
      return `${this.constructor.prefix}${this.constructor.namespace}`;
    }
    getValue(element) {
      let pairs = $(element).find(this.selectors.value).map((i, e) => [[e.value, e.checked]]).get();
      return Object.fromEntries(pairs);
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

  class CheckboxButtonInputBinding extends InputBinding {
    static get type() {
      return 'checkboxbutton';
    }
    get events() {
      return ['change'];
    }
    get selectors() {
      return {
        choice: '.btn',
        value: '.btn-check'
      };
    }
    getType(element) {
      console.log(this.constructor);
      return `${this.constructor.prefix}${this.constructor.namespace}`;
    }
    getValue(element) {
      let pairs = $(element).find(this.selectors.value).map((i, e) => [[e.value, e.checked]]).get();
      return Object.fromEntries(pairs);
    }
    receiveMessage(element, data) {
      const $element = $(element);
      const $values = $element.find(this.selectors.value);
      if (data.hasOwnProperty('options')) {
        $element.find(`${this.selectors.choice},${this.selectors.value}`).remove();
        $element.html(data.options);
      }
      if (data.hasOwnProperty('select')) {
        $values.prop('checked', false);
        console.log($values);
        console.log($values.filter((i, e) => data.select.includes(e.value)));
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
      return ['submit'];
    }
    get selectors() {
      return {
        submit: '.bsides-btn-submit'
      };
    }
    initialize(element) {
      const $element = $(element);
      let inputValues = new Map();
      $element.on(`shiny:inputchanged${this.constructor.namespace}`, event => {
        console.log(event);
        if (!event.el || event.priority === 'event') {
          return;
        }
        if (event.el.id === element.id) {
          // Shiny.setInputValue(element.id, value, { priority: 'event' })
          event.preventDefault();
          return;
        }
        if (element.contains(event.el)) {
          inputValues.set(event.name, event.value);
          event.preventDefault();
        }
      });
      $element.on(`click${this.constructor.namespace}`, this.selectors.submit, event => {
        event.preventDefault();
        for (const [key, value] of inputValues.entries()) {
          console.log(`${key}: ${value}`);
          Shiny.setInputValue(key, value, {
            priority: 'event'
          });
        }
      });
    }
    getValue(element) {
      return null;
    }
    receiveMessage(element, data) {
      const $element = $(element);
      if (data.submit === true) {
        $element.trigger(`submit${namespace}`);
      }
    }
  }

  function registerInputBindings() {
    if (Shiny) {
      const inputBindings = Shiny.inputBindings;
      inputBindings.register(new CheckboxInputBinding(), CheckboxInputBinding.type);
      inputBindings.register(new CheckboxButtonInputBinding(), CheckboxButtonInputBinding.type);
      inputBindings.register(new FormInputBinding(), FormInputBinding.type);
    }
  }

  registerInputBindings();

}));
//# sourceMappingURL=bsides.js.map
