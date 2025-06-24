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

    /*  choices(labels) {
        let $parent = $(this.element)
        let $choices =
          $parent
          .find(this.constructor.selectorChoice)
          .slice(0, labels.length)
          .map((i, el) => {
            el.innerHTML = labels[i]
            return el
          })
      }*/

    static getType(element) {
      return this.type;
    }
    static getValue(element) {
      let pairs = $(element).find(this.selectors.value).map((i, e) => [[e.value, e.checked]]).get();
      return Object.fromEntries(pairs);
    }
    static receiveMessage(element, data) {
      const $element = $(element);
      if (data.hasOwnProperty('choices')) {
        $element.find('.form-check').remove();
        $element.html(data['choices']);
      }
      $element.trigger('change');
    }
  }

  //import ButtonInput from './inputs/button.js'
  //import CheckbuttonInput from './inputs/checkbutton.js'
  //import LinkInput from './inputs/link.js'

  if (Shiny) {
    Shiny.inputBindings.register(CheckboxInput);
  }
  const bsides = {
    //  ButtonInput,
    CheckboxInput
    //  CheckbuttonInput,
    //  LinkInput
  };

  return bsides;

}));
//# sourceMappingURL=bsides.js.map
