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
      this.events.forEach(e => {
        const event = `${e.type ? e.type : e}${this.constructor.namespace}`;
        const selector = e.selector ? e.selector : null;
        console.log(`${event}, ${selector}`);
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

  function registerInputBindings() {
    if (Shiny) {
      const inputBindings = Shiny.inputBindings;
      inputBindings.register(new ButtonInputBinding(), ButtonInputBinding.type);
      inputBindings.register(new CheckboxInputBinding(), CheckboxInputBinding.type);
      inputBindings.register(new CheckboxGroupInputBinding(), CheckboxGroupInputBinding.type);
      inputBindings.register(new FormInputBinding(), FormInputBinding.type);
      inputBindings.register(new LinkInputBinding(), LinkInputBinding.type);
      inputBindings.register(new ListGroupInputBinding(), ListGroupInputBinding.type);
      inputBindings.register(new MenuInputBinding(), MenuInputBinding.type);
      inputBindings.register(new RadioGroupInputBinding(), RadioGroupInputBinding.type);
      inputBindings.register(new RangeInputBinding(), RangeInputBinding.type);
      inputBindings.register(new SelectInputBinding(), SelectInputBinding.type);
    }
  }

  registerInputBindings();

}));
//# sourceMappingURL=bsides.js.map
