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

  // srcts/src/utils/index.ts
  var pkg = {
    prefix: "bsides"
  };
  function addCustomMessageHandler(type, handler) {
    if (window.Shiny) {
      window.Shiny.addCustomMessageHandler(`${pkg.prefix}:${type}`, handler);
    }
  }
  function initialize(callback) {
    if (document.readyState === "complete") {
      callback();
    } else {
      document.addEventListener("DOMContentLoaded", callback);
    }
  }
  function registerBinding(binding) {
    if (window.Shiny) {
      window.Shiny.inputBindings.register(new binding(), `${pkg.prefix}.${binding.type}`);
    }
  }

  // srcts/src/bindings/inputs/input.ts
  var import_jquery = __toESM(require_jquery());
  var InputBinding = class {
    priority;
    static get prefix() {
      return pkg.prefix;
    }
    static get type() {
      throw new Error("not implemented");
    }
    static get namespace() {
      return `.${this.type}`;
    }
    get events() {
      return [];
    }
    constructor() {
      this.priority = "deferred";
    }
    // Typed access to static members overridden by subclasses.
    get ctor() {
      return this.constructor;
    }
    find(scope) {
      return (0, import_jquery.default)(scope).find(`.${this.ctor.prefix}-${this.ctor.type}`);
    }
    getId(element) {
      return element.id;
    }
    getType(element) {
      void element;
      return null;
    }
    getValue(element) {
      void element;
      throw new Error("not implemented");
    }
    subscribe(element, callback) {
      for (const e of this.events) {
        const type = typeof e === "string" ? e : e.type;
        const selector = typeof e === "string" ? null : e.selector ?? null;
        const event = `${type}.${this.ctor.prefix}${this.ctor.namespace}`;
        (0, import_jquery.default)(element).on(event, selector, () => {
          callback(this.priority);
        });
      }
    }
    unsubscribe(element) {
      (0, import_jquery.default)(element).off(`.${this.ctor.prefix}${this.ctor.namespace}`);
    }
    receiveMessage(element, data) {
      void element;
      void data;
      throw new Error("not implemented");
    }
    getState(element) {
      void element;
      throw new Error("not implemented");
    }
    getRatePolicy(element) {
      void element;
      return null;
    }
    initialize(element) {
      void element;
    }
    dispose(element) {
      void element;
    }
  };
  var input_default = InputBinding;

  // srcts/src/bindings/inputs/button.ts
  var import_jquery2 = __toESM(require_jquery());
  var ButtonInputBinding = class extends input_default {
    static get type() {
      return "button";
    }
    get events() {
      return ["click"];
    }
    get data() {
      return {
        clicks: `${this.ctor.prefix}-clicks`
      };
    }
    initialize(element) {
      const $element = (0, import_jquery2.default)(element);
      $element.data(this.data.clicks, 0);
      $element.on(`click${this.ctor.namespace}`, () => {
        const clicks = Number($element.data(this.data.clicks));
        $element.data(this.data.clicks, clicks + 1);
      });
    }
    getType(element) {
      void element;
      return `${this.ctor.prefix}${this.ctor.namespace}`;
    }
    getValue(element) {
      return (0, import_jquery2.default)(element).data(this.data.clicks);
    }
    receiveMessage(element, data) {
      void element;
      void data;
    }
  };
  var button_default = ButtonInputBinding;

  // srcts/src/bindings/inputs/checkbox.ts
  var import_jquery3 = __toESM(require_jquery());
  var CheckboxInputBinding = class extends input_default {
    static get type() {
      return "checkbox";
    }
    get events() {
      return ["change"];
    }
    get selectors() {
      return {
        label: ".form-check-label",
        value: ".form-check-input"
      };
    }
    getValue(element) {
      return (0, import_jquery3.default)(element).children(this.selectors.value).prop("checked");
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery3.default)(element);
      const $label = $element.find(this.selectors.label);
      const $value = $element.find(this.selectors.value);
      if (Object.hasOwn(data, "choice")) {
        $label.html(data.choice);
      }
      if (Object.hasOwn(data, "value")) {
        $value.prop("checked", data.value);
      }
      if (Object.hasOwn(data, "disable")) {
        $value.prop("disabled", data.disable);
      }
      $element.trigger("change");
    }
  };
  var checkbox_default = CheckboxInputBinding;

  // srcts/src/bindings/inputs/checkbox-group.ts
  var import_jquery4 = __toESM(require_jquery());
  var CheckboxGroupInputBinding = class extends input_default {
    static get type() {
      return "checkboxgroup";
    }
    get events() {
      return ["change"];
    }
    get selectors() {
      return {
        choice: ".form-check-label,.btn",
        value: ".form-check-input,.btn-check"
      };
    }
    getType(element) {
      void element;
      return `${this.ctor.prefix}${this.ctor.namespace}`;
    }
    getValue(element) {
      return (0, import_jquery4.default)(element).find(this.selectors.value).filter(":checked").map((i, el) => el.value).get();
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery4.default)(element);
      const $values = $element.find(this.selectors.value);
      if (Object.hasOwn(data, "options")) {
        $element.find(".form-check").remove();
        $element.html(data.options);
      }
      if (Object.hasOwn(data, "select")) {
        $values.prop("checked", false);
        $values.filter((i, e) => data.select.includes(e.value)).prop("checked", true);
      }
      if (Object.hasOwn(data, "disable")) {
        $values.prop("disabled", false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $element.trigger("change");
    }
  };
  var checkbox_group_default = CheckboxGroupInputBinding;

  // srcts/src/bindings/inputs/form.ts
  var import_jquery5 = __toESM(require_jquery());
  var FormInputBinding = class extends input_default {
    static get type() {
      return "form";
    }
    get events() {
      return [
        { type: "click", selector: this.selectors.submit }
      ];
    }
    get selectors() {
      return {
        submit: ".bsides-btn-submit"
      };
    }
    get data() {
      return {
        value: `${this.ctor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = (0, import_jquery5.default)(element);
      const inputValues = /* @__PURE__ */ new Map();
      $element.on(
        `shiny:inputchanged${this.ctor.namespace}`,
        (event) => {
          const inputEvent = event;
          if (!inputEvent.el || inputEvent.priority === "event") {
            return;
          }
          if (element.contains(inputEvent.el)) {
            const name = inputEvent.inputType ? `${inputEvent.name}:${inputEvent.inputType}` : inputEvent.name;
            inputValues.set(name, inputEvent.value);
            inputEvent.preventDefault();
          }
        }
      );
      $element.on(
        `click${this.ctor.namespace}`,
        this.selectors.submit,
        (event) => {
          event.preventDefault();
          for (const [key, value2] of inputValues.entries()) {
            window.Shiny?.setInputValue(key, value2, { priority: "event" });
          }
          const value = event.currentTarget.value;
          $element.data(this.data.value, value);
        }
      );
    }
    getValue(element) {
      return (0, import_jquery5.default)(element).data(this.data.value);
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery5.default)(element);
      if (Object.hasOwn(data, "submit")) {
        const value = data.submit;
        $element.find(`${this.selectors.submit}[value=${value}]`).trigger("click");
      }
    }
  };
  var form_default = FormInputBinding;

  // srcts/src/bindings/inputs/link.ts
  var import_jquery6 = __toESM(require_jquery());
  var LinkInputBinding = class extends input_default {
    static get type() {
      return "link";
    }
    get events() {
      return ["click"];
    }
    get data() {
      return {
        clicks: `${this.ctor.prefix}-clicks`
      };
    }
    initialize(element) {
      const $element = (0, import_jquery6.default)(element);
      $element.data(this.data.clicks, 0);
      $element.on(`click${this.ctor.namespace}`, () => {
        const clicks = Number($element.data(this.data.clicks));
        $element.data(this.data.clicks, clicks + 1);
      });
    }
    getType(element) {
      void element;
      return `${this.ctor.prefix}${this.ctor.namespace}`;
    }
    getValue(element) {
      return (0, import_jquery6.default)(element).data(this.data.clicks);
    }
  };
  var link_default = LinkInputBinding;

  // srcts/src/bindings/inputs/list-group.ts
  var import_jquery7 = __toESM(require_jquery());
  var ListGroupInputBinding = class extends input_default {
    static get type() {
      return "listgroup";
    }
    get events() {
      return ["click"];
    }
    get selectors() {
      return {
        choice: ".list-group-item-action",
        value: ".list-group-item-action"
      };
    }
    get data() {
      return {
        value: `${this.ctor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = (0, import_jquery7.default)(element);
      $element.on("click", this.selectors.choice, (event) => {
        const $choice = (0, import_jquery7.default)(event.currentTarget);
        $choice.toggleClass("active");
      });
    }
    getValue(element) {
      return (0, import_jquery7.default)(element).find(`${this.selectors.value}.active`).map((i, el) => el.getAttribute(`data-${this.data.value}`)).get();
    }
  };
  var list_group_default = ListGroupInputBinding;

  // srcts/src/bindings/inputs/menu.ts
  var import_jquery8 = __toESM(require_jquery());
  var MenuInputBinding = class extends input_default {
    static get type() {
      return "menu";
    }
    get events() {
      return [
        { type: "click", selector: this.selectors.choice }
      ];
    }
    get selectors() {
      return {
        choice: ".dropdown-item",
        value: ".dropdown-item"
      };
    }
    get data() {
      return {
        value: `${this.ctor.prefix}-value`
      };
    }
    initialize(element) {
      const $element = (0, import_jquery8.default)(element);
      $element.on("click", this.selectors.value, (event) => {
        $element.data(
          this.data.value,
          event.currentTarget.value
        );
      });
    }
    getValue(element) {
      return (0, import_jquery8.default)(element).data(this.data.value);
    }
  };
  var menu_default = MenuInputBinding;

  // srcts/src/bindings/inputs/radio-group.ts
  var import_jquery9 = __toESM(require_jquery());
  var RadioGroupInputBinding = class extends input_default {
    static get type() {
      return "radiogroup";
    }
    get events() {
      return ["change"];
    }
    get selectors() {
      return {
        choice: ".form-check-label,.btn",
        value: ".form-check-input,.btn-check"
      };
    }
    getValue(element) {
      return (0, import_jquery9.default)(element).find(this.selectors.value).filter(":checked").val();
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery9.default)(element);
      const $values = $element.find(this.selectors.value);
      if (Object.hasOwn(data, "options")) {
        $element.find(".form-check").remove();
        $element.html(data.options);
      }
      if (Object.hasOwn(data, "select")) {
        $values.prop("checked", false);
        $values.filter((i, e) => data.select.includes(e.value)).prop("checked", true);
      }
      if (Object.hasOwn(data, "disable")) {
        $values.prop("disabled", false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $element.trigger("change");
    }
  };
  var radio_group_default = RadioGroupInputBinding;

  // srcts/src/bindings/inputs/range.ts
  var import_jquery10 = __toESM(require_jquery());
  var RangeInputBinding = class extends input_default {
    static get type() {
      return "range";
    }
    get events() {
      return ["change"];
    }
    get selectors() {
      return {
        value: ".form-range"
      };
    }
    getValue(element) {
      return Number((0, import_jquery10.default)(element).find(this.selectors.value).val());
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery10.default)(element);
      const $value = $element.find(this.selectors.value);
      if (Object.hasOwn(data, "value")) {
        $value.val(data.value);
      }
      if (Object.hasOwn(data, "disable")) {
        $value.prop("disable", data.disable);
      }
      $element.trigger("change");
    }
  };
  var range_default = RangeInputBinding;

  // srcts/src/bindings/inputs/select.ts
  var import_jquery11 = __toESM(require_jquery());
  var SelectInputBinding = class extends input_default {
    static get type() {
      return "select";
    }
    get events() {
      return ["change"];
    }
    get selectors() {
      return {
        value: "option"
      };
    }
    getValue(element) {
      return element.value;
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery11.default)(element);
      if (Object.hasOwn(data, "options")) {
        $element.find(this.selectors.value).remove();
        $element.html(data.options);
      }
      if (Object.hasOwn(data, "select")) {
        $element.val(data.select);
      }
      if (Object.hasOwn(data, "disable")) {
        const $values = $element.find("option");
        $values.prop("disabled", false);
        $values.filter((i, e) => data.disable.includes(e.value)).prop("disabled", true);
      }
      $element.trigger("change");
    }
  };
  var select_default = SelectInputBinding;

  // srcts/src/bindings/inputs/text.ts
  var import_jquery12 = __toESM(require_jquery());
  var TextInputBinding = class extends input_default {
    static get type() {
      return "text";
    }
    get events() {
      return [
        "keyup",
        "input",
        "change"
      ];
    }
    get selectors() {
      return {
        value: "input"
      };
    }
    getValue(element) {
      return element.value;
    }
    getRatePolicy(element) {
      void element;
      return {
        policy: "debounce",
        delay: 250
      };
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery12.default)(element);
      if (Object.hasOwn(data, "value")) {
        $element.val(data.value);
      }
      if (Object.hasOwn(data, "disable")) {
        $element.prop("disabled", data.disable);
      }
      $element.trigger("change");
    }
  };
  var text_default = TextInputBinding;

  // srcts/src/bindings/inputs/text-group.ts
  var import_jquery13 = __toESM(require_jquery());
  var TextGroupInputBinding = class extends input_default {
    static get type() {
      return "textgroup";
    }
    get events() {
      return [
        "keyup",
        "input",
        "change"
      ];
    }
    get selectors() {
      return {
        value: "input",
        text: ".input-group-text"
      };
    }
    getValue(element) {
      const $element = (0, import_jquery13.default)(element);
      if (!$element.find(this.selectors.value).val()) {
        return null;
      }
      return $element.find(`${this.selectors.text},${this.selectors.value}`).map((i, e) => e.innerText || e.value || "").get().join("");
    }
    getRatePolicy(element) {
      void element;
      return {
        policy: "debounce",
        delay: 250
      };
    }
    receiveMessage(element, data) {
      const $element = (0, import_jquery13.default)(element);
      const $value = $element.find(this.selectors.value);
      if (Object.hasOwn(data, "value")) {
        $value.val(data.value);
      }
      if (Object.hasOwn(data, "disable")) {
        $value.prop("disabled", data.disable);
      }
      $element.trigger("change");
    }
  };
  var text_group_default = TextGroupInputBinding;

  // srcts/src/bindings/inputs/multi-select.ts
  var import_jquery14 = __toESM(require_jquery());
  var Chip = class _Chip {
    #element;
    static #instances = /* @__PURE__ */ new WeakMap();
    constructor(element) {
      this.#element = element;
      _Chip.#instances.set(element, this);
    }
    close() {
      const $element = (0, import_jquery14.default)(this.#element);
      $element.trigger("close.bsides.chip");
      $element.fadeOut(200, () => this.#remove());
    }
    #remove() {
      this.#element.remove();
      (0, import_jquery14.default)(this.#element).trigger("closed.bsides.chip");
      _Chip.#instances.delete(this.#element);
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
      (0, import_jquery14.default)(document).on("click.bsides.chip", '[data-bs-dismiss="chip"]', (event) => {
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
      (0, import_jquery14.default)(this.#element).trigger("update.bsides.multiselect");
    }
    static getInstance(element) {
      return _MultiSelectInput.#instances.get(element);
    }
    static addEventListeners() {
      const $document = (0, import_jquery14.default)(document);
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
      $document.on("close.bsides.chip", ".multi-select", (event) => {
        (0, import_jquery14.default)(event.currentTarget).trigger("update.bsides.multiselect");
      });
    }
  };
  var MultiSelectInputBinding = class extends input_default {
    static get type() {
      return "multiselect";
    }
    get events() {
      return [
        "update.bsides.multiselect"
      ];
    }
    getType(element) {
      void element;
      return null;
    }
    getValue(element) {
      const multiSelect = MultiSelectInput.getInstance(element);
      if (!multiSelect) {
        return void 0;
      }
      return multiSelect.value();
    }
    initialize(element) {
      new MultiSelectInput(element);
    }
    receiveMessage(element, data) {
      void element;
      void data;
    }
  };
  Chip.addEventListeners();
  MultiSelectInput.addEventListeners();
  registerBinding(MultiSelectInputBinding);

  // srcts/src/bindings/inputs/index.ts
  function registerInputs() {
    registerBinding(button_default);
    registerBinding(checkbox_default);
    registerBinding(checkbox_group_default);
    registerBinding(form_default);
    registerBinding(link_default);
    registerBinding(list_group_default);
    registerBinding(menu_default);
    registerBinding(radio_group_default);
    registerBinding(range_default);
    registerBinding(select_default);
    registerBinding(text_default);
    registerBinding(text_group_default);
  }

  // srcts/src/components/toast.ts
  var import_bootstrap = __toESM(require_bootstrap());
  var Toast = class extends import_bootstrap.Toast {
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
        if (!container || !window.Shiny) {
          return;
        }
        await window.Shiny.renderContentAsync(container, data.toast, "beforeend");
      });
    }
  };
  var ToastInputBinding = class extends input_default {
    static get type() {
      return "toast";
    }
    get events() {
      return [
        "shown.bs.toast",
        "hidden.bs.toast"
      ];
    }
    initialize(element) {
      new Toast(element);
    }
    getValue(element) {
      const toast = Toast.getInstance(element);
      if (!toast) {
        return void 0;
      }
      return toast.state;
    }
    receiveMessage(element, data) {
      const toast = Toast.getInstance(element);
      if (!toast) {
        return;
      }
      if (data.method === "show") {
        toast.show(data.duration);
      } else if (data.method === "hide") {
        toast.hide();
      }
    }
  };
  Toast.addMessageHandlers();
  registerBinding(ToastInputBinding);

  // srcts/src/components/modal.ts
  var import_bootstrap2 = __toESM(require_bootstrap());
  var Modal = class _Modal extends import_bootstrap2.Modal {
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
    }
    static async showOrInsertModal(content) {
      const el = document.createElement("div");
      el.innerHTML = content.html;
      const id = el.firstChild && el.firstChild.id;
      if (!id || !window.Shiny) {
        return;
      }
      const existing = document.getElementById(id);
      if (existing) {
        window.Shiny.unbindAll(existing, true);
        existing.remove();
      }
      await window.Shiny.renderContentAsync(document.body, content, "beforeend");
      const target = document.getElementById(id);
      if (!target) {
        return;
      }
      const modal = new _Modal(target);
      modal.show();
    }
  };
  var ModalInputBinding = class extends input_default {
    static get type() {
      return "modal";
    }
    get events() {
      return [
        "shown.bs.modal",
        "hidden.bs.modal"
      ];
    }
    getValue(element) {
      const modal = Modal.getInstance(element);
      if (!modal) {
        return null;
      }
      return modal.isShown() ? "shown" : "hidden";
    }
  };
  Modal.addMessageHandlers();
  registerBinding(ModalInputBinding);

  // srcts/src/index.ts
  initialize(() => {
    registerInputs();
  });
})();
//# sourceMappingURL=bsides.js.map
