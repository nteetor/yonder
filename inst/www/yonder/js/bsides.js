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

  class Input {
    static get type() {
      return `bsides.${this.name}`;
    }
    static get namespace() {
      return `.${this.type}`;
    }
    static get priority() {
      return 'deferred';
    }
    static get events() {
      return [];
    }
    static find(scope) {
      return $(scope).find(`.bsides-${this.name}`);
    }
    static getId(element) {
      return element.id;
    }
    static getType(element) {
      return null;
    }
    static getValue(element) {
      throw 'not implemented';
    }
    static subscribe(element, callback) {
      this.events.forEach(event => {
        $(element).on(`${event}${this.namespace}`, () => {
          callback(this.priority);
        });
      });
    }
    static unsubscribe(element) {
      $(element).off(this.namespace);
    }
    static receiveMessage(element, data) {
      throw 'not implemented';
    }
    static getState(element) {
      let input = InputStore.get(element, this.type);
      if (!input) {
        return;
      }
      return {
        value: input.values()
      };
    }

    // @return { policy: RatePolicyModes, delay: number }
    static getRatePolicy(element) {
      return null;
    }
    static initialize(element) {}
    static dispose(element) {}
  }

  class CheckboxInput extends Input {
    static get name() {
      return 'checkbox';
    }
    static get events() {
      return ['change'];
    }
    static get selectors() {
      return {
        choice: '.form-check-label',
        value: '.form-check-input'
      };
    }
    static getType(element) {
      return this.type;
    }
    static getValue(element) {
      let pairs = $(element).find(this.selectors.value).map((i, e) => [[e.value, e.checked]]).get();
      return Object.fromEntries(pairs);
    }
    static receiveMessage(element, data) {
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

  class CheckboxButtonInput extends Input {
    static get name() {
      return 'checkbox-button';
    }
    static get events() {
      return ['change'];
    }
    static get selectors() {
      return {
        choice: '.btn',
        value: '.btn-check'
      };
    }
    static getType(element) {
      return this.type;
    }
    static getValue(element) {
      let pairs = $(element).find(this.selectors.value).map((i, e) => [[e.value, e.checked]]).get();
      return Object.fromEntries(pairs);
    }
    static receiveMessage(element, data) {
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

  //import ButtonInput from './inputs/button.js'
  //import LinkInput from './inputs/link.js'

  if (Shiny) {
    Shiny.inputBindings.register(CheckboxInput);
    Shiny.inputBindings.register(CheckboxButtonInput);
  }
  const bsides = {
    //  ButtonInput,
    CheckboxInput,
    CheckboxButtonInput
    //  LinkInput
  };

  return bsides;

}));
//# sourceMappingURL=bsides.js.map
