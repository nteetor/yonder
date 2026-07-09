/*!
  * bsides v0.2.0.9000 (https://nteetor.github.com/yonder)
  * Copyright 2011-2026 Nathan Teetor <nate@haufin.ch>
  * Licensed under MIT (https://github.com/nteetor/yonder/blob/main/LICENSE.note)
  */
"use strict";
(() => {
  var __create = Object.create;
  var __defProp = Object.defineProperty;
  var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
  var __getOwnPropNames = Object.getOwnPropertyNames;
  var __getProtoOf = Object.getPrototypeOf;
  var __hasOwnProp = Object.prototype.hasOwnProperty;
  var __commonJS = (cb, mod) => function __require() {
    return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
  };
  var __copyProps = (to, from, except, desc) => {
    if (from && typeof from === "object" || typeof from === "function") {
      for (let key of __getOwnPropNames(from))
        if (!__hasOwnProp.call(to, key) && key !== except)
          __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
    }
    return to;
  };
  var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
    // If the importer is in node compatibility mode or this is not an ESM
    // file that has been converted to a CommonJS file using a Babel-
    // compatible transform (i.e. "__esModule" has not been set), then set
    // "default" to the CommonJS "module.exports" for node compatibility.
    isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
    mod
  ));

  // globals:jquery
  var require_jquery = __commonJS({
    "globals:jquery"(exports, module) {
      module.exports = window.jQuery;
    }
  });

  // globals:bootstrap
  var require_bootstrap = __commonJS({
    "globals:bootstrap"(exports, module) {
      module.exports = window.bootstrap;
    }
  });

  // srcts/src/components/inputButton.ts
  var import_jquery = __toESM(require_jquery());

  // srcts/src/components/_utils.ts
  var Shiny = window.Shiny;
  var InputBinding = Shiny ? Shiny.InputBinding : class {
  };
  function registerBinding(inputBindingClass, name) {
    if (Shiny) {
      Shiny.inputBindings.register(new inputBindingClass(), "bsides." + name);
    }
  }
  function addCustomMessageHandler(type, handler) {
    if (Shiny) {
      Shiny.addCustomMessageHandler("bsides:" + type, handler);
    }
  }
  function hasDefinedProperty(obj, prop) {
    return Object.prototype.hasOwnProperty.call(obj, prop) && obj[prop] !== void 0;
  }

  // srcts/src/components/inputButton.ts
  var ButtonInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery.default)(scope).find(".bsides-button");
    }
    getValue(el) {
      return Number((0, import_jquery.default)(el).data("bsides-clicks")) || 0;
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.button";
    }
    subscribe(el, callback) {
      (0, import_jquery.default)(el).on("click.bsidesButtonInputBinding", () => {
        const clicks = Number((0, import_jquery.default)(el).data("bsides-clicks")) || 0;
        (0, import_jquery.default)(el).data("bsides-clicks", clicks + 1);
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery.default)(el).off(".bsidesButtonInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const button = el;
      if (hasDefinedProperty(data, "text")) {
        button.innerHTML = data.text;
      }
      if (hasDefinedProperty(data, "disable")) {
        button.disabled = data.disable;
      }
    }
  };
  registerBinding(ButtonInputBinding, "button");

  // srcts/src/components/inputCheckbox.ts
  var import_jquery2 = __toESM(require_jquery());
  var CheckboxInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery2.default)(scope).find(".bsides-checkbox");
    }
    getValue(el) {
      return (0, import_jquery2.default)(el).children(".form-check-input").prop("checked");
    }
    subscribe(el, callback) {
      (0, import_jquery2.default)(el).on("change.bsidesCheckboxInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery2.default)(el).off(".bsidesCheckboxInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery2.default)(el);
      if (hasDefinedProperty(data, "choice")) {
        $el.find(".form-check-label").html(data.choice);
      }
      if (hasDefinedProperty(data, "value")) {
        $el.find(".form-check-input").prop("checked", data.value);
      }
      if (hasDefinedProperty(data, "disable")) {
        $el.find(".form-check-input").prop("disabled", data.disable);
      }
      $el.trigger("change");
    }
  };
  registerBinding(CheckboxInputBinding, "checkbox");

  // srcts/src/components/inputCheckboxGroup.ts
  var import_jquery3 = __toESM(require_jquery());
  var CheckboxGroupInputBinding = class extends InputBinding {
    get selectors() {
      return {
        value: ".form-check-input,.btn-check"
      };
    }
    find(scope) {
      return (0, import_jquery3.default)(scope).find(".bsides-checkboxgroup");
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.checkboxgroup";
    }
    getValue(el) {
      return (0, import_jquery3.default)(el).find(this.selectors.value).filter(":checked").map((i, e) => e.value).get();
    }
    subscribe(el, callback) {
      (0, import_jquery3.default)(el).on("change.bsidesCheckboxGroupInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery3.default)(el).off(".bsidesCheckboxGroupInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery3.default)(el);
      if (hasDefinedProperty(data, "options")) {
        $el.html(data.options);
      }
      const $values = $el.find(this.selectors.value);
      if (hasDefinedProperty(data, "select")) {
        $values.prop("checked", false);
        $values.filter((i, e) => data.select.includes(e.value)).prop("checked", true);
      }
      if (hasDefinedProperty(data, "disable")) {
        $values.prop("disabled", false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $el.trigger("change");
    }
  };
  registerBinding(CheckboxGroupInputBinding, "checkboxgroup");

  // srcts/src/components/inputForm.ts
  var import_jquery4 = __toESM(require_jquery());
  var FormInputBinding = class extends InputBinding {
    get selectors() {
      return {
        submit: ".bsides-btn-submit"
      };
    }
    find(scope) {
      return (0, import_jquery4.default)(scope).find(".bsides-form");
    }
    getValue(el) {
      return (0, import_jquery4.default)(el).data("bsides-value");
    }
    subscribe(el, callback) {
      const $el = (0, import_jquery4.default)(el);
      const inputValues = /* @__PURE__ */ new Map();
      $el.on("shiny:inputchanged.bsidesFormInputBinding", (event) => {
        const inputEvent = event;
        if (!inputEvent.el || inputEvent.priority === "event") {
          return;
        }
        if (inputEvent.el !== el && el.contains(inputEvent.el)) {
          const name = inputEvent.inputType ? `${inputEvent.name}:${inputEvent.inputType}` : inputEvent.name;
          inputValues.set(name, inputEvent.value);
          inputEvent.preventDefault();
        }
      });
      $el.on(
        "click.bsidesFormInputBinding",
        this.selectors.submit,
        (event) => {
          event.preventDefault();
          for (const [key, value] of inputValues.entries()) {
            Shiny?.setInputValue?.(key, value, { priority: "event" });
          }
          $el.data("bsides-value", event.currentTarget.value);
          callback(false);
        }
      );
    }
    unsubscribe(el) {
      (0, import_jquery4.default)(el).off(".bsidesFormInputBinding");
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "submit")) {
        (0, import_jquery4.default)(el).find(`${this.selectors.submit}[value=${data.submit}]`).trigger("click");
      }
    }
  };
  registerBinding(FormInputBinding, "form");

  // srcts/src/components/inputLink.ts
  var import_jquery5 = __toESM(require_jquery());
  var LinkInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery5.default)(scope).find(".bsides-link");
    }
    getValue(el) {
      return Number((0, import_jquery5.default)(el).data("bsides-clicks")) || 0;
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.link";
    }
    subscribe(el, callback) {
      (0, import_jquery5.default)(el).on("click.bsidesLinkInputBinding", () => {
        const clicks = Number((0, import_jquery5.default)(el).data("bsides-clicks")) || 0;
        (0, import_jquery5.default)(el).data("bsides-clicks", clicks + 1);
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery5.default)(el).off(".bsidesLinkInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      if (data.label != null) {
        el.innerHTML = data.label;
      }
    }
  };
  registerBinding(LinkInputBinding, "link");

  // srcts/src/components/inputListGroup.ts
  var import_jquery6 = __toESM(require_jquery());
  var ListGroupInputBinding = class extends InputBinding {
    get selectors() {
      return {
        choice: ".list-group-item-action"
      };
    }
    find(scope) {
      return (0, import_jquery6.default)(scope).find(".bsides-listgroup");
    }
    getValue(el) {
      return (0, import_jquery6.default)(el).find(`${this.selectors.choice}.active`).map((i, e) => e.getAttribute("data-bsides-value")).get();
    }
    subscribe(el, callback) {
      const $el = (0, import_jquery6.default)(el);
      $el.on(
        "click.bsidesListGroupInputBinding",
        this.selectors.choice,
        (event) => {
          (0, import_jquery6.default)(event.currentTarget).toggleClass("active");
          callback(false);
        }
      );
      $el.on("change.bsidesListGroupInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery6.default)(el).off(".bsidesListGroupInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery6.default)(el);
      const $choices = $el.find(this.selectors.choice);
      const valueOf = (e) => e.getAttribute("data-bsides-value") ?? "";
      if (hasDefinedProperty(data, "select")) {
        $choices.removeClass("active");
        $choices.filter((i, e) => data.select.includes(valueOf(e))).addClass("active");
      }
      if (hasDefinedProperty(data, "disable")) {
        $choices.removeClass("disabled").prop("disabled", false);
        $choices.filter((i, e) => data.disable.includes(valueOf(e))).addClass("disabled").prop("disabled", true);
      }
      $el.trigger("change");
    }
  };
  registerBinding(ListGroupInputBinding, "listgroup");

  // srcts/src/components/inputMenu.ts
  var import_jquery7 = __toESM(require_jquery());
  var MenuInputBinding = class extends InputBinding {
    get selectors() {
      return {
        toggle: ".dropdown-toggle",
        choice: ".dropdown-item"
      };
    }
    find(scope) {
      return (0, import_jquery7.default)(scope).find(".bsides-menu");
    }
    getValue(el) {
      return (0, import_jquery7.default)(el).data("bsides-value");
    }
    subscribe(el, callback) {
      const $el = (0, import_jquery7.default)(el);
      $el.on("click.bsidesMenuInputBinding", this.selectors.choice, (event) => {
        $el.data("bsides-value", event.currentTarget.value);
        callback(false);
      });
      $el.on("change.bsidesMenuInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery7.default)(el).off(".bsidesMenuInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery7.default)(el);
      if (hasDefinedProperty(data, "label")) {
        $el.children(this.selectors.toggle).html(data.label);
      }
      if (hasDefinedProperty(data, "disable")) {
        const $choices = $el.find(this.selectors.choice);
        $choices.prop("disabled", false).removeClass("disabled");
        $choices.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true).addClass("disabled");
      }
      if (hasDefinedProperty(data, "select")) {
        $el.data("bsides-value", data.select);
        $el.trigger("change");
      }
    }
  };
  registerBinding(MenuInputBinding, "menu");

  // srcts/src/components/inputMultiSelect.ts
  var import_jquery8 = __toESM(require_jquery());
  var Chip = class _Chip {
    #element;
    static #instances = /* @__PURE__ */ new WeakMap();
    constructor(element) {
      this.#element = element;
      _Chip.#instances.set(element, this);
    }
    close() {
      const $element = (0, import_jquery8.default)(this.#element);
      $element.trigger("close.bsides.chip");
      $element.fadeOut(200, () => this.#remove());
    }
    #remove() {
      const parent = this.#element.parentElement;
      this.#element.remove();
      _Chip.#instances.delete(this.#element);
      if (parent) {
        (0, import_jquery8.default)(parent).trigger("closed.bsides.chip");
      }
    }
    static createElement(text) {
      if (!text) {
        return void 0;
      }
      const chip = document.createElement("div");
      chip.classList.add("chip");
      chip.setAttribute("data-value", text);
      const closeButton = document.createElement("button");
      closeButton.setAttribute("type", "button");
      closeButton.setAttribute("data-bs-dismiss", "chip");
      closeButton.classList.add("btn-close");
      chip.innerText = text;
      chip.appendChild(closeButton);
      return chip;
    }
    static getInstance(element) {
      return _Chip.#instances.get(element);
    }
    static getOrCreateInstance(element) {
      return this.getInstance(element) ?? new this(element);
    }
    static addEventListeners() {
      (0, import_jquery8.default)(document).on("click.bsides.chip", '[data-bs-dismiss="chip"]', (event) => {
        const element = event.currentTarget.parentElement;
        if (!element) {
          return;
        }
        const chip = new _Chip(element);
        chip.close();
      });
    }
  };
  var MultiSelectInput = class _MultiSelectInput {
    #element;
    #chipGroupElement;
    #textInputElement;
    static #instances = /* @__PURE__ */ new WeakMap();
    constructor(element) {
      this.#element = element;
      this.#textInputElement = element.querySelector(
        ".multi-select-input"
      );
      this.#chipGroupElement = element.querySelector(".chip-group");
      _MultiSelectInput.#instances.set(element, this);
    }
    value() {
      return Array.from(this.#chipGroupElement.children).map((chip) => {
        return chip.dataset.value;
      });
    }
    text() {
      return (this.#textInputElement.value || "").trim();
    }
    add() {
      const chip = Chip.createElement(this.text());
      if (!chip) {
        return;
      }
      new Chip(chip);
      this.#chipGroupElement.appendChild(chip);
      this.#textInputElement.value = "";
      (0, import_jquery8.default)(this.#element).trigger("update.bsides.multiselect");
    }
    static getInstance(element) {
      return _MultiSelectInput.#instances.get(element);
    }
    static addEventListeners() {
      const $document = (0, import_jquery8.default)(document);
      $document.on("keyup.bsides.multiselect", ".multi-select", (event) => {
        if (event.key === "Enter" || event.keyCode === 13) {
          const multiSelect = _MultiSelectInput.getInstance(
            event.currentTarget
          );
          if (!multiSelect) {
            return;
          }
          multiSelect.add();
        }
      });
      $document.on("closed.bsides.chip", ".multi-select", (event) => {
        (0, import_jquery8.default)(event.currentTarget).trigger("update.bsides.multiselect");
      });
    }
  };
  var MultiSelectInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery8.default)(scope).find(".bsides-multiselect");
    }
    initialize(el) {
      new MultiSelectInput(el);
    }
    getValue(el) {
      const multiSelect = MultiSelectInput.getInstance(el);
      if (!multiSelect) {
        return void 0;
      }
      return multiSelect.value();
    }
    subscribe(el, callback) {
      (0, import_jquery8.default)(el).on("update.bsides.multiselect", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery8.default)(el).off("update.bsides.multiselect");
    }
    // update_multi_select() is still a stub on the R side; nothing to receive
    // yet.
    receiveMessage(el, data) {
      void el;
      void data;
    }
  };
  Chip.addEventListeners();
  MultiSelectInput.addEventListeners();
  registerBinding(MultiSelectInputBinding, "multiselect");

  // srcts/src/components/inputRadioGroup.ts
  var import_jquery9 = __toESM(require_jquery());
  var RadioGroupInputBinding = class extends InputBinding {
    get selectors() {
      return {
        value: ".form-check-input,.btn-check"
      };
    }
    find(scope) {
      return (0, import_jquery9.default)(scope).find(".bsides-radiogroup");
    }
    getValue(el) {
      return (0, import_jquery9.default)(el).find(this.selectors.value).filter(":checked").val();
    }
    subscribe(el, callback) {
      (0, import_jquery9.default)(el).on("change.bsidesRadioGroupInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery9.default)(el).off(".bsidesRadioGroupInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery9.default)(el);
      if (hasDefinedProperty(data, "options")) {
        $el.html(data.options);
      }
      const $values = $el.find(this.selectors.value);
      if (hasDefinedProperty(data, "select")) {
        $values.prop("checked", false);
        $values.filter((i, e) => data.select.includes(e.value)).prop("checked", true);
      }
      if (hasDefinedProperty(data, "disable")) {
        $values.prop("disabled", false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $el.trigger("change");
    }
  };
  registerBinding(RadioGroupInputBinding, "radiogroup");

  // srcts/src/components/inputRange.ts
  var import_jquery10 = __toESM(require_jquery());
  var RangeInputBinding = class extends InputBinding {
    get selectors() {
      return {
        value: ".form-range"
      };
    }
    find(scope) {
      return (0, import_jquery10.default)(scope).find(".bsides-range");
    }
    getValue(el) {
      return Number((0, import_jquery10.default)(el).find(this.selectors.value).val());
    }
    subscribe(el, callback) {
      (0, import_jquery10.default)(el).on("change.bsidesRangeInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery10.default)(el).off(".bsidesRangeInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery10.default)(el);
      const $value = $el.find(this.selectors.value);
      if (hasDefinedProperty(data, "value")) {
        $value.val(data.value);
      }
      if (hasDefinedProperty(data, "disable")) {
        $value.prop("disabled", data.disable);
      }
      $el.trigger("change");
    }
  };
  registerBinding(RangeInputBinding, "range");

  // srcts/src/components/inputSelect.ts
  var import_jquery11 = __toESM(require_jquery());
  var SelectInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery11.default)(scope).find(".bsides-select");
    }
    getValue(el) {
      return el.value;
    }
    setValue(el, value) {
      el.value = value;
    }
    subscribe(el, callback) {
      (0, import_jquery11.default)(el).on("change.bsidesSelectInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery11.default)(el).off(".bsidesSelectInputBinding");
    }
    getState(el) {
      return {
        value: el.value
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery11.default)(el);
      if (hasDefinedProperty(data, "options")) {
        $el.html(data.options);
      }
      if (hasDefinedProperty(data, "select")) {
        this.setValue(el, data.select);
      }
      if (hasDefinedProperty(data, "disable")) {
        const $options = $el.find("option");
        $options.prop("disabled", false);
        $options.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $el.trigger("change");
    }
  };
  registerBinding(SelectInputBinding, "select");

  // srcts/src/components/inputText.ts
  var import_jquery12 = __toESM(require_jquery());
  var TextInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery12.default)(scope).find(".bsides-text");
    }
    getValue(el) {
      return el.value;
    }
    setValue(el, value) {
      el.value = value;
    }
    subscribe(el, callback) {
      const $el = (0, import_jquery12.default)(el);
      $el.on("keyup.bsidesTextInputBinding input.bsidesTextInputBinding", () => {
        callback(true);
      });
      $el.on("change.bsidesTextInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery12.default)(el).off(".bsidesTextInputBinding");
    }
    getState(el) {
      return {
        value: el.value
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "value")) {
        this.setValue(el, data.value);
      }
      if (hasDefinedProperty(data, "disable")) {
        el.disabled = data.disable;
      }
      (0, import_jquery12.default)(el).trigger("change");
    }
    getRatePolicy(el) {
      void el;
      return {
        policy: "debounce",
        delay: 250
      };
    }
  };
  registerBinding(TextInputBinding, "text");

  // srcts/src/components/inputTextGroup.ts
  var import_jquery13 = __toESM(require_jquery());
  var TextGroupInputBinding = class extends InputBinding {
    get selectors() {
      return {
        value: "input",
        text: ".input-group-text"
      };
    }
    find(scope) {
      return (0, import_jquery13.default)(scope).find(".bsides-textgroup");
    }
    getValue(el) {
      const $el = (0, import_jquery13.default)(el);
      if (!$el.find(this.selectors.value).val()) {
        return null;
      }
      return $el.find(`${this.selectors.text},${this.selectors.value}`).map((i, e) => e.textContent || e.value || "").get().join("");
    }
    subscribe(el, callback) {
      const $el = (0, import_jquery13.default)(el);
      $el.on(
        "keyup.bsidesTextGroupInputBinding input.bsidesTextGroupInputBinding",
        () => {
          callback(true);
        }
      );
      $el.on("change.bsidesTextGroupInputBinding", () => {
        callback(false);
      });
    }
    unsubscribe(el) {
      (0, import_jquery13.default)(el).off(".bsidesTextGroupInputBinding");
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    getRatePolicy(el) {
      void el;
      return {
        policy: "debounce",
        delay: 250
      };
    }
    receiveMessage(el, data) {
      const $el = (0, import_jquery13.default)(el);
      const $value = $el.find(this.selectors.value);
      if (hasDefinedProperty(data, "value")) {
        $value.val(data.value);
      }
      if (hasDefinedProperty(data, "disable")) {
        $value.prop("disabled", data.disable);
      }
      $el.trigger("change");
    }
  };
  registerBinding(TextGroupInputBinding, "textgroup");

  // srcts/src/components/modal.ts
  var import_jquery14 = __toESM(require_jquery());
  var import_bootstrap = __toESM(require_bootstrap());
  var Modal = class _Modal extends import_bootstrap.Modal {
    isShown() {
      return this._isShown;
    }
    static addMessageHandlers() {
      addCustomMessageHandler("modalShow", (data) => {
        if (typeof data.modal === "object") {
          _Modal.showOrInsertModal(data.modal);
        } else {
          const el = document.getElementById(data.modal);
          if (!el) {
            return;
          }
          const modal = _Modal.getOrCreateInstance(el);
          modal.show();
        }
      });
      addCustomMessageHandler("modalClose", (data) => {
        void data;
        for (const el of document.querySelectorAll(".modal.show")) {
          ;
          _Modal.getInstance(el)?.hide();
        }
      });
    }
    static async showOrInsertModal(content) {
      const el = document.createElement("div");
      el.innerHTML = content.html;
      const id = el.firstChild && el.firstChild.id;
      if (!id || !Shiny) {
        return;
      }
      const existing = document.getElementById(id);
      if (existing) {
        Shiny.unbindAll?.(existing, true);
        existing.remove();
      }
      await Shiny.renderContentAsync(document.body, content, "beforeEnd");
      const target = document.getElementById(id);
      if (!target) {
        return;
      }
      const modal = new _Modal(target);
      modal.show();
    }
  };
  var ModalInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery14.default)(scope).find(".bsides-modal");
    }
    getValue(el) {
      const modal = Modal.getInstance(el);
      if (!modal) {
        return null;
      }
      return modal.isShown() ? "shown" : "hidden";
    }
    subscribe(el, callback) {
      (0, import_jquery14.default)(el).on(
        "shown.bs.modal.bsidesModalInputBinding hidden.bs.modal.bsidesModalInputBinding",
        () => {
          callback(false);
        }
      );
    }
    unsubscribe(el) {
      (0, import_jquery14.default)(el).off(".bsidesModalInputBinding");
    }
  };
  Modal.addMessageHandlers();
  registerBinding(ModalInputBinding, "modal");

  // srcts/src/components/toast.ts
  var import_jquery15 = __toESM(require_jquery());
  var import_bootstrap2 = __toESM(require_bootstrap());
  var Toast = class extends import_bootstrap2.Toast {
    constructor(toast) {
      super(toast, {});
    }
    get state() {
      return this.isShown() ? "shown" : "hidden";
    }
    show(duration) {
      if (duration) {
        const config = this._config;
        config.delay = duration;
        config.autohide = true;
      }
      super.show();
    }
    static addMessageHandlers() {
      addCustomMessageHandler("toastAdd", async (data) => {
        if (!data.target) {
          return;
        }
        const container = document.getElementById(data.target);
        if (!container || !Shiny) {
          return;
        }
        await Shiny.renderContentAsync(container, data.toast, "beforeEnd");
      });
    }
  };
  var ToastInputBinding = class extends InputBinding {
    find(scope) {
      return (0, import_jquery15.default)(scope).find(".bsides-toast");
    }
    initialize(el) {
      new Toast(el);
    }
    getValue(el) {
      const toast = Toast.getInstance(el);
      if (!toast) {
        return void 0;
      }
      return toast.state;
    }
    subscribe(el, callback) {
      (0, import_jquery15.default)(el).on(
        "shown.bs.toast.bsidesToastInputBinding hidden.bs.toast.bsidesToastInputBinding",
        () => {
          callback(false);
        }
      );
    }
    unsubscribe(el) {
      (0, import_jquery15.default)(el).off(".bsidesToastInputBinding");
    }
    receiveMessage(el, data) {
      const toast = Toast.getInstance(el);
      if (!toast) {
        return;
      }
      if (data.method === "show") {
        toast.show(hasDefinedProperty(data, "duration") ? data.duration : void 0);
      } else if (data.method === "hide") {
        toast.hide();
      }
    }
  };
  Toast.addMessageHandlers();
  registerBinding(ToastInputBinding, "toast");
})();
//# sourceMappingURL=bsides.js.map
