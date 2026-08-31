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
    try {
      return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
    } catch (e5) {
      throw mod = 0, e5;
    }
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

  // globals:bootstrap
  var require_bootstrap = __commonJS({
    "globals:bootstrap"(exports, module) {
      module.exports = window.bootstrap;
    }
  });

  // srcts/src/components/_utils.ts
  var Shiny = window.Shiny;
  var InputBinding = Shiny ? Shiny.InputBinding : class {
  };
  function registerBinding(inputBindingClass, name) {
    if (Shiny) {
      Shiny.inputBindings.register(new inputBindingClass(), "bsides." + name);
    }
  }
  function findAll(scope, selector) {
    const roots = typeof scope.querySelectorAll === "function" ? [scope] : Array.from(scope);
    const found = /* @__PURE__ */ new Set();
    for (const root of roots) {
      for (const el of root.querySelectorAll(selector)) {
        found.add(el);
      }
    }
    return [...found];
  }
  function announce(el) {
    el.dispatchEvent(new Event("change", { bubbles: true }));
  }
  var NativeEventInputBinding = class extends InputBinding {
    #controllers = /* @__PURE__ */ new WeakMap();
    listen(el, type, handler) {
      let controller = this.#controllers.get(el);
      if (!controller) {
        controller = new AbortController();
        this.#controllers.set(el, controller);
      }
      el.addEventListener(type, handler, { signal: controller.signal });
    }
    listenDelegated(el, type, selector, handler) {
      this.listen(el, type, (event) => {
        const target = event.target?.closest(
          selector
        );
        if (target && el.contains(target)) {
          handler(event, target);
        }
      });
    }
    unsubscribe(el) {
      this.#controllers.get(el)?.abort();
      this.#controllers.delete(el);
    }
  };
  function addCustomMessageHandler(type, handler) {
    if (Shiny) {
      Shiny.addCustomMessageHandler("bsides:" + type, handler);
    }
  }
  function hasDefinedProperty(obj, prop) {
    return Object.prototype.hasOwnProperty.call(obj, prop) && obj[prop] !== void 0;
  }

  // srcts/src/components/inputButton.ts
  var clicks = /* @__PURE__ */ new WeakMap();
  var ButtonInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-button");
    }
    getValue(el) {
      return clicks.get(el) ?? 0;
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.button";
    }
    subscribe(el, callback) {
      this.listen(el, "click", () => {
        clicks.set(el, this.getValue(el) + 1);
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const button = el;
      if (hasDefinedProperty(data, "label")) {
        button.innerHTML = data.label;
      }
      if (hasDefinedProperty(data, "disable")) {
        button.disabled = data.disable;
      }
    }
  };
  registerBinding(ButtonInputBinding, "button");

  // srcts/src/components/inputCheckbox.ts
  var CheckboxInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-checkbox");
    }
    getValue(el) {
      return this.#checkboxOf(el).checked;
    }
    subscribe(el, callback) {
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "choice")) {
        const label = el.querySelector(".form-check-label");
        if (label) {
          label.innerHTML = data.choice;
        }
      }
      if (hasDefinedProperty(data, "value")) {
        this.#checkboxOf(el).checked = data.value;
      }
      if (hasDefinedProperty(data, "disable")) {
        this.#checkboxOf(el).disabled = data.disable;
      }
      announce(el);
    }
    #checkboxOf(el) {
      return el.querySelector(":scope > .form-check-input");
    }
  };
  registerBinding(CheckboxInputBinding, "checkbox");

  // srcts/src/components/inputCheckboxGroup.ts
  var CheckboxGroupInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-checkbox-group");
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.checkboxgroup";
    }
    getValue(el) {
      return this.#checkboxesOf(el).filter((checkbox) => checkbox.checked).map((checkbox) => checkbox.value);
    }
    subscribe(el, callback) {
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "options")) {
        el.innerHTML = data.options;
      }
      const checkboxes = this.#checkboxesOf(el);
      if (hasDefinedProperty(data, "select")) {
        for (const checkbox of checkboxes) {
          checkbox.checked = data.select.includes(checkbox.value);
        }
      }
      if (hasDefinedProperty(data, "disable")) {
        for (const checkbox of checkboxes) {
          checkbox.disabled = data.disable.includes(checkbox.value);
        }
      }
      announce(el);
    }
    #checkboxesOf(el) {
      return [
        ...el.querySelectorAll(".form-check-input,.btn-check")
      ];
    }
  };
  registerBinding(CheckboxGroupInputBinding, "checkboxgroup");

  // node_modules/@lit/reactive-element/css-tag.js
  var t = globalThis;
  var e = t.ShadowRoot && (void 0 === t.ShadyCSS || t.ShadyCSS.nativeShadow) && "adoptedStyleSheets" in Document.prototype && "replace" in CSSStyleSheet.prototype;
  var s = /* @__PURE__ */ Symbol();
  var o = /* @__PURE__ */ new WeakMap();
  var n = class {
    constructor(t5, e5, o6) {
      if (this._$cssResult$ = true, o6 !== s) throw Error("CSSResult is not constructable. Use `unsafeCSS` or `css` instead.");
      this.cssText = t5, this.t = e5;
    }
    get styleSheet() {
      let t5 = this.o;
      const s5 = this.t;
      if (e && void 0 === t5) {
        const e5 = void 0 !== s5 && 1 === s5.length;
        e5 && (t5 = o.get(s5)), void 0 === t5 && ((this.o = t5 = new CSSStyleSheet()).replaceSync(this.cssText), e5 && o.set(s5, t5));
      }
      return t5;
    }
    toString() {
      return this.cssText;
    }
  };
  var r = (t5) => new n("string" == typeof t5 ? t5 : t5 + "", void 0, s);
  var S = (s5, o6) => {
    if (e) s5.adoptedStyleSheets = o6.map((t5) => t5 instanceof CSSStyleSheet ? t5 : t5.styleSheet);
    else for (const e5 of o6) {
      const o7 = document.createElement("style"), n4 = t.litNonce;
      void 0 !== n4 && o7.setAttribute("nonce", n4), o7.textContent = e5.cssText, s5.appendChild(o7);
    }
  };
  var c = e ? (t5) => t5 : (t5) => t5 instanceof CSSStyleSheet ? ((t6) => {
    let e5 = "";
    for (const s5 of t6.cssRules) e5 += s5.cssText;
    return r(e5);
  })(t5) : t5;

  // node_modules/@lit/reactive-element/reactive-element.js
  var { is: i2, defineProperty: e2, getOwnPropertyDescriptor: h, getOwnPropertyNames: r2, getOwnPropertySymbols: o2, getPrototypeOf: n2 } = Object;
  var a = globalThis;
  var c2 = a.trustedTypes;
  var l = c2 ? c2.emptyScript : "";
  var p = a.reactiveElementPolyfillSupport;
  var d = (t5, s5) => t5;
  var u = { toAttribute(t5, s5) {
    switch (s5) {
      case Boolean:
        t5 = t5 ? l : null;
        break;
      case Object:
      case Array:
        t5 = null == t5 ? t5 : JSON.stringify(t5);
    }
    return t5;
  }, fromAttribute(t5, s5) {
    let i7 = t5;
    switch (s5) {
      case Boolean:
        i7 = null !== t5;
        break;
      case Number:
        i7 = null === t5 ? null : Number(t5);
        break;
      case Object:
      case Array:
        try {
          i7 = JSON.parse(t5);
        } catch (t6) {
          i7 = null;
        }
    }
    return i7;
  } };
  var f = (t5, s5) => !i2(t5, s5);
  var b = { attribute: true, type: String, converter: u, reflect: false, useDefault: false, hasChanged: f };
  Symbol.metadata ??= /* @__PURE__ */ Symbol("metadata"), a.litPropertyMetadata ??= /* @__PURE__ */ new WeakMap();
  var y = class extends HTMLElement {
    static addInitializer(t5) {
      this._$Ei(), (this.l ??= []).push(t5);
    }
    static get observedAttributes() {
      return this.finalize(), this._$Eh && [...this._$Eh.keys()];
    }
    static createProperty(t5, s5 = b) {
      if (s5.state && (s5.attribute = false), this._$Ei(), this.prototype.hasOwnProperty(t5) && ((s5 = Object.create(s5)).wrapped = true), this.elementProperties.set(t5, s5), !s5.noAccessor) {
        const i7 = /* @__PURE__ */ Symbol(), h4 = this.getPropertyDescriptor(t5, i7, s5);
        void 0 !== h4 && e2(this.prototype, t5, h4);
      }
    }
    static getPropertyDescriptor(t5, s5, i7) {
      const { get: e5, set: r4 } = h(this.prototype, t5) ?? { get() {
        return this[s5];
      }, set(t6) {
        this[s5] = t6;
      } };
      return { get: e5, set(s6) {
        const h4 = e5?.call(this);
        r4?.call(this, s6), this.requestUpdate(t5, h4, i7);
      }, configurable: true, enumerable: true };
    }
    static getPropertyOptions(t5) {
      return this.elementProperties.get(t5) ?? b;
    }
    static _$Ei() {
      if (this.hasOwnProperty(d("elementProperties"))) return;
      const t5 = n2(this);
      t5.finalize(), void 0 !== t5.l && (this.l = [...t5.l]), this.elementProperties = new Map(t5.elementProperties);
    }
    static finalize() {
      if (this.hasOwnProperty(d("finalized"))) return;
      if (this.finalized = true, this._$Ei(), this.hasOwnProperty(d("properties"))) {
        const t6 = this.properties, s5 = [...r2(t6), ...o2(t6)];
        for (const i7 of s5) this.createProperty(i7, t6[i7]);
      }
      const t5 = this[Symbol.metadata];
      if (null !== t5) {
        const s5 = litPropertyMetadata.get(t5);
        if (void 0 !== s5) for (const [t6, i7] of s5) this.elementProperties.set(t6, i7);
      }
      this._$Eh = /* @__PURE__ */ new Map();
      for (const [t6, s5] of this.elementProperties) {
        const i7 = this._$Eu(t6, s5);
        void 0 !== i7 && this._$Eh.set(i7, t6);
      }
      this.elementStyles = this.finalizeStyles(this.styles);
    }
    static finalizeStyles(s5) {
      const i7 = [];
      if (Array.isArray(s5)) {
        const e5 = new Set(s5.flat(1 / 0).reverse());
        for (const s6 of e5) i7.unshift(c(s6));
      } else void 0 !== s5 && i7.push(c(s5));
      return i7;
    }
    static _$Eu(t5, s5) {
      const i7 = s5.attribute;
      return false === i7 ? void 0 : "string" == typeof i7 ? i7 : "string" == typeof t5 ? t5.toLowerCase() : void 0;
    }
    constructor() {
      super(), this._$Ep = void 0, this.isUpdatePending = false, this.hasUpdated = false, this._$Em = null, this._$Ev();
    }
    _$Ev() {
      this._$ES = new Promise((t5) => this.enableUpdating = t5), this._$AL = /* @__PURE__ */ new Map(), this._$E_(), this.requestUpdate(), this.constructor.l?.forEach((t5) => t5(this));
    }
    addController(t5) {
      (this._$EO ??= /* @__PURE__ */ new Set()).add(t5), void 0 !== this.renderRoot && this.isConnected && t5.hostConnected?.();
    }
    removeController(t5) {
      this._$EO?.delete(t5);
    }
    _$E_() {
      const t5 = /* @__PURE__ */ new Map(), s5 = this.constructor.elementProperties;
      for (const i7 of s5.keys()) this.hasOwnProperty(i7) && (t5.set(i7, this[i7]), delete this[i7]);
      t5.size > 0 && (this._$Ep = t5);
    }
    createRenderRoot() {
      const t5 = this.shadowRoot ?? this.attachShadow(this.constructor.shadowRootOptions);
      return S(t5, this.constructor.elementStyles), t5;
    }
    connectedCallback() {
      this.renderRoot ??= this.createRenderRoot(), this.enableUpdating(true), this._$EO?.forEach((t5) => t5.hostConnected?.());
    }
    enableUpdating(t5) {
    }
    disconnectedCallback() {
      this._$EO?.forEach((t5) => t5.hostDisconnected?.());
    }
    attributeChangedCallback(t5, s5, i7) {
      this._$AK(t5, i7);
    }
    _$ET(t5, s5) {
      const i7 = this.constructor.elementProperties.get(t5), e5 = this.constructor._$Eu(t5, i7);
      if (void 0 !== e5 && true === i7.reflect) {
        const h4 = (void 0 !== i7.converter?.toAttribute ? i7.converter : u).toAttribute(s5, i7.type);
        this._$Em = t5, null == h4 ? this.removeAttribute(e5) : this.setAttribute(e5, h4), this._$Em = null;
      }
    }
    _$AK(t5, s5) {
      const i7 = this.constructor, e5 = i7._$Eh.get(t5);
      if (void 0 !== e5 && this._$Em !== e5) {
        const t6 = i7.getPropertyOptions(e5), h4 = "function" == typeof t6.converter ? { fromAttribute: t6.converter } : void 0 !== t6.converter?.fromAttribute ? t6.converter : u;
        this._$Em = e5;
        const r4 = h4.fromAttribute(s5, t6.type);
        this[e5] = r4 ?? this._$Ej?.get(e5) ?? r4, this._$Em = null;
      }
    }
    requestUpdate(t5, s5, i7, e5 = false, h4) {
      if (void 0 !== t5) {
        const r4 = this.constructor;
        if (false === e5 && (h4 = this[t5]), i7 ??= r4.getPropertyOptions(t5), !((i7.hasChanged ?? f)(h4, s5) || i7.useDefault && i7.reflect && h4 === this._$Ej?.get(t5) && !this.hasAttribute(r4._$Eu(t5, i7)))) return;
        this.C(t5, s5, i7);
      }
      false === this.isUpdatePending && (this._$ES = this._$EP());
    }
    C(t5, s5, { useDefault: i7, reflect: e5, wrapped: h4 }, r4) {
      i7 && !(this._$Ej ??= /* @__PURE__ */ new Map()).has(t5) && (this._$Ej.set(t5, r4 ?? s5 ?? this[t5]), true !== h4 || void 0 !== r4) || (this._$AL.has(t5) || (this.hasUpdated || i7 || (s5 = void 0), this._$AL.set(t5, s5)), true === e5 && this._$Em !== t5 && (this._$Eq ??= /* @__PURE__ */ new Set()).add(t5));
    }
    async _$EP() {
      this.isUpdatePending = true;
      try {
        await this._$ES;
      } catch (t6) {
        Promise.reject(t6);
      }
      const t5 = this.scheduleUpdate();
      return null != t5 && await t5, !this.isUpdatePending;
    }
    scheduleUpdate() {
      return this.performUpdate();
    }
    performUpdate() {
      if (!this.isUpdatePending) return;
      if (!this.hasUpdated) {
        if (this.renderRoot ??= this.createRenderRoot(), this._$Ep) {
          for (const [t7, s6] of this._$Ep) this[t7] = s6;
          this._$Ep = void 0;
        }
        const t6 = this.constructor.elementProperties;
        if (t6.size > 0) for (const [s6, i7] of t6) {
          const { wrapped: t7 } = i7, e5 = this[s6];
          true !== t7 || this._$AL.has(s6) || void 0 === e5 || this.C(s6, void 0, i7, e5);
        }
      }
      let t5 = false;
      const s5 = this._$AL;
      try {
        t5 = this.shouldUpdate(s5), t5 ? (this.willUpdate(s5), this._$EO?.forEach((t6) => t6.hostUpdate?.()), this.update(s5)) : this._$EM();
      } catch (s6) {
        throw t5 = false, this._$EM(), s6;
      }
      t5 && this._$AE(s5);
    }
    willUpdate(t5) {
    }
    _$AE(t5) {
      this._$EO?.forEach((t6) => t6.hostUpdated?.()), this.hasUpdated || (this.hasUpdated = true, this.firstUpdated(t5)), this.updated(t5);
    }
    _$EM() {
      this._$AL = /* @__PURE__ */ new Map(), this.isUpdatePending = false;
    }
    get updateComplete() {
      return this.getUpdateComplete();
    }
    getUpdateComplete() {
      return this._$ES;
    }
    shouldUpdate(t5) {
      return true;
    }
    update(t5) {
      this._$Eq &&= this._$Eq.forEach((t6) => this._$ET(t6, this[t6])), this._$EM();
    }
    updated(t5) {
    }
    firstUpdated(t5) {
    }
  };
  y.elementStyles = [], y.shadowRootOptions = { mode: "open" }, y[d("elementProperties")] = /* @__PURE__ */ new Map(), y[d("finalized")] = /* @__PURE__ */ new Map(), p?.({ ReactiveElement: y }), (a.reactiveElementVersions ??= []).push("2.1.2");

  // node_modules/lit-html/lit-html.js
  var t2 = globalThis;
  var i3 = (t5) => t5;
  var s2 = t2.trustedTypes;
  var e3 = s2 ? s2.createPolicy("lit-html", { createHTML: (t5) => t5 }) : void 0;
  var h2 = "$lit$";
  var o3 = `lit$${Math.random().toFixed(9).slice(2)}$`;
  var n3 = "?" + o3;
  var r3 = `<${n3}>`;
  var l2 = document;
  var c3 = () => l2.createComment("");
  var a2 = (t5) => null === t5 || "object" != typeof t5 && "function" != typeof t5;
  var u2 = Array.isArray;
  var d2 = (t5) => u2(t5) || "function" == typeof t5?.[Symbol.iterator];
  var f2 = "[ 	\n\f\r]";
  var v = /<(?:(!--|\/[^a-zA-Z])|(\/?[a-zA-Z][^>\s]*)|(\/?$))/g;
  var _ = /-->/g;
  var m = />/g;
  var p2 = RegExp(`>|${f2}(?:([^\\s"'>=/]+)(${f2}*=${f2}*(?:[^ 	
\f\r"'\`<>=]|("|')|))|$)`, "g");
  var g = /'/g;
  var $ = /"/g;
  var y2 = /^(?:script|style|textarea|title)$/i;
  var x = (t5) => (i7, ...s5) => ({ _$litType$: t5, strings: i7, values: s5 });
  var b2 = x(1);
  var w = x(2);
  var T = x(3);
  var E = /* @__PURE__ */ Symbol.for("lit-noChange");
  var A = /* @__PURE__ */ Symbol.for("lit-nothing");
  var C = /* @__PURE__ */ new WeakMap();
  var P = l2.createTreeWalker(l2, 129);
  function V(t5, i7) {
    if (!u2(t5) || !t5.hasOwnProperty("raw")) throw Error("invalid template strings array");
    return void 0 !== e3 ? e3.createHTML(i7) : i7;
  }
  var N = (t5, i7) => {
    const s5 = t5.length - 1, e5 = [];
    let n4, l3 = 2 === i7 ? "<svg>" : 3 === i7 ? "<math>" : "", c5 = v;
    for (let i8 = 0; i8 < s5; i8++) {
      const s6 = t5[i8];
      let a3, u5, d3 = -1, f3 = 0;
      for (; f3 < s6.length && (c5.lastIndex = f3, u5 = c5.exec(s6), null !== u5); ) f3 = c5.lastIndex, c5 === v ? "!--" === u5[1] ? c5 = _ : void 0 !== u5[1] ? c5 = m : void 0 !== u5[2] ? (y2.test(u5[2]) && (n4 = RegExp("</" + u5[2], "g")), c5 = p2) : void 0 !== u5[3] && (c5 = p2) : c5 === p2 ? ">" === u5[0] ? (c5 = n4 ?? v, d3 = -1) : void 0 === u5[1] ? d3 = -2 : (d3 = c5.lastIndex - u5[2].length, a3 = u5[1], c5 = void 0 === u5[3] ? p2 : '"' === u5[3] ? $ : g) : c5 === $ || c5 === g ? c5 = p2 : c5 === _ || c5 === m ? c5 = v : (c5 = p2, n4 = void 0);
      const x2 = c5 === p2 && t5[i8 + 1].startsWith("/>") ? " " : "";
      l3 += c5 === v ? s6 + r3 : d3 >= 0 ? (e5.push(a3), s6.slice(0, d3) + h2 + s6.slice(d3) + o3 + x2) : s6 + o3 + (-2 === d3 ? i8 : x2);
    }
    return [V(t5, l3 + (t5[s5] || "<?>") + (2 === i7 ? "</svg>" : 3 === i7 ? "</math>" : "")), e5];
  };
  var S2 = class _S {
    constructor({ strings: t5, _$litType$: i7 }, e5) {
      let r4;
      this.parts = [];
      let l3 = 0, a3 = 0;
      const u5 = t5.length - 1, d3 = this.parts, [f3, v3] = N(t5, i7);
      if (this.el = _S.createElement(f3, e5), P.currentNode = this.el.content, 2 === i7 || 3 === i7) {
        const t6 = this.el.content.firstChild;
        t6.replaceWith(...t6.childNodes);
      }
      for (; null !== (r4 = P.nextNode()) && d3.length < u5; ) {
        if (1 === r4.nodeType) {
          if (r4.hasAttributes()) for (const t6 of r4.getAttributeNames()) if (t6.endsWith(h2)) {
            const i8 = v3[a3++], s5 = r4.getAttribute(t6).split(o3), e6 = /([.?@])?(.*)/.exec(i8);
            d3.push({ type: 1, index: l3, name: e6[2], strings: s5, ctor: "." === e6[1] ? I : "?" === e6[1] ? L : "@" === e6[1] ? z : H }), r4.removeAttribute(t6);
          } else t6.startsWith(o3) && (d3.push({ type: 6, index: l3 }), r4.removeAttribute(t6));
          if (y2.test(r4.tagName)) {
            const t6 = r4.textContent.split(o3), i8 = t6.length - 1;
            if (i8 > 0) {
              r4.textContent = s2 ? s2.emptyScript : "";
              for (let s5 = 0; s5 < i8; s5++) r4.append(t6[s5], c3()), P.nextNode(), d3.push({ type: 2, index: ++l3 });
              r4.append(t6[i8], c3());
            }
          }
        } else if (8 === r4.nodeType) if (r4.data === n3) d3.push({ type: 2, index: l3 });
        else {
          let t6 = -1;
          for (; -1 !== (t6 = r4.data.indexOf(o3, t6 + 1)); ) d3.push({ type: 7, index: l3 }), t6 += o3.length - 1;
        }
        l3++;
      }
    }
    static createElement(t5, i7) {
      const s5 = l2.createElement("template");
      return s5.innerHTML = t5, s5;
    }
  };
  function M(t5, i7, s5 = t5, e5) {
    if (i7 === E) return i7;
    let h4 = void 0 !== e5 ? s5._$Co?.[e5] : s5._$Cl;
    const o6 = a2(i7) ? void 0 : i7._$litDirective$;
    return h4?.constructor !== o6 && (h4?._$AO?.(false), void 0 === o6 ? h4 = void 0 : (h4 = new o6(t5), h4._$AT(t5, s5, e5)), void 0 !== e5 ? (s5._$Co ??= [])[e5] = h4 : s5._$Cl = h4), void 0 !== h4 && (i7 = M(t5, h4._$AS(t5, i7.values), h4, e5)), i7;
  }
  var R = class {
    constructor(t5, i7) {
      this._$AV = [], this._$AN = void 0, this._$AD = t5, this._$AM = i7;
    }
    get parentNode() {
      return this._$AM.parentNode;
    }
    get _$AU() {
      return this._$AM._$AU;
    }
    u(t5) {
      const { el: { content: i7 }, parts: s5 } = this._$AD, e5 = (t5?.creationScope ?? l2).importNode(i7, true);
      P.currentNode = e5;
      let h4 = P.nextNode(), o6 = 0, n4 = 0, r4 = s5[0];
      for (; void 0 !== r4; ) {
        if (o6 === r4.index) {
          let i8;
          2 === r4.type ? i8 = new k(h4, h4.nextSibling, this, t5) : 1 === r4.type ? i8 = new r4.ctor(h4, r4.name, r4.strings, this, t5) : 6 === r4.type && (i8 = new Z(h4, this, t5)), this._$AV.push(i8), r4 = s5[++n4];
        }
        o6 !== r4?.index && (h4 = P.nextNode(), o6++);
      }
      return P.currentNode = l2, e5;
    }
    p(t5) {
      let i7 = 0;
      for (const s5 of this._$AV) void 0 !== s5 && (void 0 !== s5.strings ? (s5._$AI(t5, s5, i7), i7 += s5.strings.length - 2) : s5._$AI(t5[i7])), i7++;
    }
  };
  var k = class _k {
    get _$AU() {
      return this._$AM?._$AU ?? this._$Cv;
    }
    constructor(t5, i7, s5, e5) {
      this.type = 2, this._$AH = A, this._$AN = void 0, this._$AA = t5, this._$AB = i7, this._$AM = s5, this.options = e5, this._$Cv = e5?.isConnected ?? true;
    }
    get parentNode() {
      let t5 = this._$AA.parentNode;
      const i7 = this._$AM;
      return void 0 !== i7 && 11 === t5?.nodeType && (t5 = i7.parentNode), t5;
    }
    get startNode() {
      return this._$AA;
    }
    get endNode() {
      return this._$AB;
    }
    _$AI(t5, i7 = this) {
      t5 = M(this, t5, i7), a2(t5) ? t5 === A || null == t5 || "" === t5 ? (this._$AH !== A && this._$AR(), this._$AH = A) : t5 !== this._$AH && t5 !== E && this._(t5) : void 0 !== t5._$litType$ ? this.$(t5) : void 0 !== t5.nodeType ? this.T(t5) : d2(t5) ? this.k(t5) : this._(t5);
    }
    O(t5) {
      return this._$AA.parentNode.insertBefore(t5, this._$AB);
    }
    T(t5) {
      this._$AH !== t5 && (this._$AR(), this._$AH = this.O(t5));
    }
    _(t5) {
      this._$AH !== A && a2(this._$AH) ? this._$AA.nextSibling.data = t5 : this.T(l2.createTextNode(t5)), this._$AH = t5;
    }
    $(t5) {
      const { values: i7, _$litType$: s5 } = t5, e5 = "number" == typeof s5 ? this._$AC(t5) : (void 0 === s5.el && (s5.el = S2.createElement(V(s5.h, s5.h[0]), this.options)), s5);
      if (this._$AH?._$AD === e5) this._$AH.p(i7);
      else {
        const t6 = new R(e5, this), s6 = t6.u(this.options);
        t6.p(i7), this.T(s6), this._$AH = t6;
      }
    }
    _$AC(t5) {
      let i7 = C.get(t5.strings);
      return void 0 === i7 && C.set(t5.strings, i7 = new S2(t5)), i7;
    }
    k(t5) {
      u2(this._$AH) || (this._$AH = [], this._$AR());
      const i7 = this._$AH;
      let s5, e5 = 0;
      for (const h4 of t5) e5 === i7.length ? i7.push(s5 = new _k(this.O(c3()), this.O(c3()), this, this.options)) : s5 = i7[e5], s5._$AI(h4), e5++;
      e5 < i7.length && (this._$AR(s5 && s5._$AB.nextSibling, e5), i7.length = e5);
    }
    _$AR(t5 = this._$AA.nextSibling, s5) {
      for (this._$AP?.(false, true, s5); t5 !== this._$AB; ) {
        const s6 = i3(t5).nextSibling;
        i3(t5).remove(), t5 = s6;
      }
    }
    setConnected(t5) {
      void 0 === this._$AM && (this._$Cv = t5, this._$AP?.(t5));
    }
  };
  var H = class {
    get tagName() {
      return this.element.tagName;
    }
    get _$AU() {
      return this._$AM._$AU;
    }
    constructor(t5, i7, s5, e5, h4) {
      this.type = 1, this._$AH = A, this._$AN = void 0, this.element = t5, this.name = i7, this._$AM = e5, this.options = h4, s5.length > 2 || "" !== s5[0] || "" !== s5[1] ? (this._$AH = Array(s5.length - 1).fill(new String()), this.strings = s5) : this._$AH = A;
    }
    _$AI(t5, i7 = this, s5, e5) {
      const h4 = this.strings;
      let o6 = false;
      if (void 0 === h4) t5 = M(this, t5, i7, 0), o6 = !a2(t5) || t5 !== this._$AH && t5 !== E, o6 && (this._$AH = t5);
      else {
        const e6 = t5;
        let n4, r4;
        for (t5 = h4[0], n4 = 0; n4 < h4.length - 1; n4++) r4 = M(this, e6[s5 + n4], i7, n4), r4 === E && (r4 = this._$AH[n4]), o6 ||= !a2(r4) || r4 !== this._$AH[n4], r4 === A ? t5 = A : t5 !== A && (t5 += (r4 ?? "") + h4[n4 + 1]), this._$AH[n4] = r4;
      }
      o6 && !e5 && this.j(t5);
    }
    j(t5) {
      t5 === A ? this.element.removeAttribute(this.name) : this.element.setAttribute(this.name, t5 ?? "");
    }
  };
  var I = class extends H {
    constructor() {
      super(...arguments), this.type = 3;
    }
    j(t5) {
      this.element[this.name] = t5 === A ? void 0 : t5;
    }
  };
  var L = class extends H {
    constructor() {
      super(...arguments), this.type = 4;
    }
    j(t5) {
      this.element.toggleAttribute(this.name, !!t5 && t5 !== A);
    }
  };
  var z = class extends H {
    constructor(t5, i7, s5, e5, h4) {
      super(t5, i7, s5, e5, h4), this.type = 5;
    }
    _$AI(t5, i7 = this) {
      if ((t5 = M(this, t5, i7, 0) ?? A) === E) return;
      const s5 = this._$AH, e5 = t5 === A && s5 !== A || t5.capture !== s5.capture || t5.once !== s5.once || t5.passive !== s5.passive, h4 = t5 !== A && (s5 === A || e5);
      e5 && this.element.removeEventListener(this.name, this, s5), h4 && this.element.addEventListener(this.name, this, t5), this._$AH = t5;
    }
    handleEvent(t5) {
      "function" == typeof this._$AH ? this._$AH.call(this.options?.host ?? this.element, t5) : this._$AH.handleEvent(t5);
    }
  };
  var Z = class {
    constructor(t5, i7, s5) {
      this.element = t5, this.type = 6, this._$AN = void 0, this._$AM = i7, this.options = s5;
    }
    get _$AU() {
      return this._$AM._$AU;
    }
    _$AI(t5) {
      M(this, t5);
    }
  };
  var j = { M: h2, P: o3, A: n3, C: 1, L: N, R, D: d2, V: M, I: k, H, N: L, U: z, B: I, F: Z };
  var B = t2.litHtmlPolyfillSupport;
  B?.(S2, k), (t2.litHtmlVersions ??= []).push("3.3.3");
  var D = (t5, i7, s5) => {
    const e5 = s5?.renderBefore ?? i7;
    let h4 = e5._$litPart$;
    if (void 0 === h4) {
      const t6 = s5?.renderBefore ?? null;
      e5._$litPart$ = h4 = new k(i7.insertBefore(c3(), t6), t6, void 0, s5 ?? {});
    }
    return h4._$AI(t5), h4;
  };

  // node_modules/lit-element/lit-element.js
  var s3 = globalThis;
  var i4 = class extends y {
    constructor() {
      super(...arguments), this.renderOptions = { host: this }, this._$Do = void 0;
    }
    createRenderRoot() {
      const t5 = super.createRenderRoot();
      return this.renderOptions.renderBefore ??= t5.firstChild, t5;
    }
    update(t5) {
      const r4 = this.render();
      this.hasUpdated || (this.renderOptions.isConnected = this.isConnected), super.update(t5), this._$Do = D(r4, this.renderRoot, this.renderOptions);
    }
    connectedCallback() {
      super.connectedCallback(), this._$Do?.setConnected(true);
    }
    disconnectedCallback() {
      super.disconnectedCallback(), this._$Do?.setConnected(false);
    }
    render() {
      return E;
    }
  };
  i4._$litElement$ = true, i4["finalized"] = true, s3.litElementHydrateSupport?.({ LitElement: i4 });
  var o4 = s3.litElementPolyfillSupport;
  o4?.({ LitElement: i4 });
  (s3.litElementVersions ??= []).push("4.2.2");

  // node_modules/lit-html/directive.js
  var t3 = { ATTRIBUTE: 1, CHILD: 2, PROPERTY: 3, BOOLEAN_ATTRIBUTE: 4, EVENT: 5, ELEMENT: 6 };
  var e4 = (t5) => (...e5) => ({ _$litDirective$: t5, values: e5 });
  var i5 = class {
    constructor(t5) {
    }
    get _$AU() {
      return this._$AM._$AU;
    }
    _$AT(t5, e5, i7) {
      this._$Ct = t5, this._$AM = e5, this._$Ci = i7;
    }
    _$AS(t5, e5) {
      return this.update(t5, e5);
    }
    update(t5, e5) {
      return this.render(...e5);
    }
  };

  // node_modules/lit-html/directive-helpers.js
  var { I: t4 } = j;
  var i6 = (o6) => o6;
  var s4 = () => document.createComment("");
  var v2 = (o6, n4, e5) => {
    const l3 = o6._$AA.parentNode, d3 = void 0 === n4 ? o6._$AB : n4._$AA;
    if (void 0 === e5) {
      const i7 = l3.insertBefore(s4(), d3), n5 = l3.insertBefore(s4(), d3);
      e5 = new t4(i7, n5, o6, o6.options);
    } else {
      const t5 = e5._$AB.nextSibling, n5 = e5._$AM, c5 = n5 !== o6;
      if (c5) {
        let t6;
        e5._$AQ?.(o6), e5._$AM = o6, void 0 !== e5._$AP && (t6 = o6._$AU) !== n5._$AU && e5._$AP(t6);
      }
      if (t5 !== d3 || c5) {
        let o7 = e5._$AA;
        for (; o7 !== t5; ) {
          const t6 = i6(o7).nextSibling;
          i6(l3).insertBefore(o7, d3), o7 = t6;
        }
      }
    }
    return e5;
  };
  var u3 = (o6, t5, i7 = o6) => (o6._$AI(t5, i7), o6);
  var m2 = {};
  var p3 = (o6, t5 = m2) => o6._$AH = t5;
  var M2 = (o6) => o6._$AH;
  var h3 = (o6) => {
    o6._$AR(), o6._$AA.remove();
  };

  // node_modules/lit-html/directives/repeat.js
  var u4 = (e5, s5, t5) => {
    const r4 = /* @__PURE__ */ new Map();
    for (let l3 = s5; l3 <= t5; l3++) r4.set(e5[l3], l3);
    return r4;
  };
  var c4 = e4(class extends i5 {
    constructor(e5) {
      if (super(e5), e5.type !== t3.CHILD) throw Error("repeat() can only be used in text expressions");
    }
    dt(e5, s5, t5) {
      let r4;
      void 0 === t5 ? t5 = s5 : void 0 !== s5 && (r4 = s5);
      const l3 = [], o6 = [];
      let i7 = 0;
      for (const s6 of e5) l3[i7] = r4 ? r4(s6, i7) : i7, o6[i7] = t5(s6, i7), i7++;
      return { values: o6, keys: l3 };
    }
    render(e5, s5, t5) {
      return this.dt(e5, s5, t5).values;
    }
    update(s5, [t5, r4, c5]) {
      const d3 = M2(s5), { values: p4, keys: a3 } = this.dt(t5, r4, c5);
      if (!Array.isArray(d3)) return this.ut = a3, p4;
      const h4 = this.ut ??= [], v3 = [];
      let m3, y3, x2 = 0, j2 = d3.length - 1, k2 = 0, w2 = p4.length - 1;
      for (; x2 <= j2 && k2 <= w2; ) if (null === d3[x2]) x2++;
      else if (null === d3[j2]) j2--;
      else if (h4[x2] === a3[k2]) v3[k2] = u3(d3[x2], p4[k2]), x2++, k2++;
      else if (h4[j2] === a3[w2]) v3[w2] = u3(d3[j2], p4[w2]), j2--, w2--;
      else if (h4[x2] === a3[w2]) v3[w2] = u3(d3[x2], p4[w2]), v2(s5, v3[w2 + 1], d3[x2]), x2++, w2--;
      else if (h4[j2] === a3[k2]) v3[k2] = u3(d3[j2], p4[k2]), v2(s5, d3[x2], d3[j2]), j2--, k2++;
      else if (void 0 === m3 && (m3 = u4(a3, k2, w2), y3 = u4(h4, x2, j2)), m3.has(h4[x2])) if (m3.has(h4[j2])) {
        const e5 = y3.get(a3[k2]), t6 = void 0 !== e5 ? d3[e5] : null;
        if (null === t6) {
          const e6 = v2(s5, d3[x2]);
          u3(e6, p4[k2]), v3[k2] = e6;
        } else v3[k2] = u3(t6, p4[k2]), v2(s5, d3[x2], t6), d3[e5] = null;
        k2++;
      } else h3(d3[j2]), j2--;
      else h3(d3[x2]), x2++;
      for (; k2 <= w2; ) {
        const e5 = v2(s5, v3[w2 + 1]);
        u3(e5, p4[k2]), v3[k2++] = e5;
      }
      for (; x2 <= j2; ) {
        const e5 = d3[x2++];
        null !== e5 && h3(e5);
      }
      return this.ut = a3, p3(s5, v3), E;
    }
  });

  // srcts/src/components/webcomponents/chip.ts
  var BsidesChip = class extends i4 {
    static properties = {
      value: { type: String },
      label: { type: String },
      checkable: { type: Boolean, reflect: true },
      checked: { type: Boolean, reflect: true },
      type: { type: String },
      removable: { type: Boolean, reflect: true },
      disabled: { type: Boolean, reflect: true }
    };
    #appliedType = "";
    constructor() {
      super();
      this.value = "";
      this.label = "";
      this.checkable = false;
      this.checked = false;
      this.type = "";
      this.removable = false;
      this.disabled = false;
      this.addEventListener("click", this.#onClick);
      this.addEventListener("keydown", this.#onKeydown);
    }
    // Render into light DOM so Bootstrap variables and the bsides theme apply.
    createRenderRoot() {
      return this;
    }
    // Host attributes and theme classes depend on reactive properties, so
    // they are (re)applied after every update.
    updated() {
      if (this.checkable) {
        this.setAttribute("role", "button");
        this.setAttribute("tabindex", this.disabled ? "-1" : "0");
        this.setAttribute("aria-pressed", this.checked ? "true" : "false");
      } else {
        this.removeAttribute("aria-pressed");
      }
      this.#applyType();
    }
    // The class is constant per type; checked/unchecked looks are derived in
    // CSS from the reflected attributes.
    #applyType() {
      if (this.#appliedType && this.#appliedType !== this.type) {
        this.classList.remove(`chip-${this.#appliedType}`);
      }
      this.#appliedType = this.type;
      if (this.type) {
        this.classList.add(`chip-${this.type}`);
      }
    }
    render() {
      const label = this.label || this.value;
      return b2`${this.checked ? b2`<svg
          class="chip-check"
          viewBox="0 0 16 16"
          width="1em"
          height="1em"
          fill="none"
          stroke="currentColor"
          stroke-width="2.5"
          stroke-linecap="round"
          stroke-linejoin="round"
          aria-hidden="true"
        >
          <path d="M3 8.5 6.5 12 13 4.5" />
        </svg>` : A}${label}${this.removable ? b2`<button
          type="button"
          class="btn-close"
          aria-label=${`Remove ${label}`}
          ?disabled=${this.disabled}
          @click=${this.#onRemoveClick}
        ></button>` : A}`;
    }
    #onClick = (event) => {
      if (!this.checkable || this.disabled) {
        return;
      }
      if (event.target.closest(".btn-close")) {
        return;
      }
      this.#requestToggle();
    };
    #onKeydown = (event) => {
      if (!this.checkable || this.disabled || event.target !== this) {
        return;
      }
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        this.#requestToggle();
      }
    };
    #requestToggle() {
      this.dispatchEvent(
        new CustomEvent("bsides-chip:toggle", {
          detail: { value: this.value },
          bubbles: true
        })
      );
    }
    #onRemoveClick = () => {
      this.dispatchEvent(
        new CustomEvent("bsides-chip:remove", {
          detail: { value: this.value },
          bubbles: true
        })
      );
    };
  };
  customElements.define("bsides-chip", BsidesChip);

  // srcts/src/components/webcomponents/chipGroup.ts
  var BsidesChipGroup = class extends i4 {
    static properties = {
      choices: { type: Array },
      checked: { type: Array },
      type: { type: String },
      layout: { type: String, reflect: true },
      disabled: { type: Boolean, reflect: true },
      label: { type: String },
      _announcement: { state: true }
    };
    constructor() {
      super();
      this.choices = [];
      this.checked = [];
      this.type = "primary";
      this.layout = "vertical";
      this.disabled = false;
      this.label = "";
      this._announcement = "";
      this.addEventListener("bsides-chip:toggle", this.#onChipToggle);
    }
    createRenderRoot() {
      return this;
    }
    render() {
      return b2`
      <div
        class="chip-group-chips"
        role="group"
        aria-label=${this.label || "Chips"}
      >
        ${c4(
        this.choices,
        (choice) => choice.value,
        (choice) => b2`<bsides-chip
            .value=${choice.value}
            .label=${choice.label}
            .type=${this.type}
            checkable
            ?checked=${this.checked.includes(choice.value)}
            ?disabled=${this.disabled}
          ></bsides-chip>`
      )}
      </div>
      <span class="visually-hidden" aria-live="polite">
        ${this._announcement}
      </span>
    `;
    }
    // Apply a server update (update_chip_group() → receiveMessage() → here).
    // All state changes stay inside the component; a change event is
    // dispatched afterwards so the binding reports the (possibly new) value.
    receiveUpdate(msg) {
      if (msg.choices !== void 0) {
        this.choices = msg.choices;
        this.checked = this.checked.filter((value) => this.#isChoice(value));
      }
      if (msg.select !== void 0) {
        const select = Array.isArray(msg.select) ? msg.select : [msg.select];
        const known = select.filter((value) => this.#isChoice(value));
        if (known.length !== select.length) {
          console.warn(
            `bsides-chip-group: dropping value(s) not found in choices: ` + select.filter((value) => !this.#isChoice(value)).join(", ")
          );
        }
        this.checked = this.choices.map((choice) => choice.value).filter((value) => known.includes(value));
      }
      if (msg.enable === true) {
        this.disabled = false;
      }
      if (msg.disable === true) {
        this.disabled = true;
      }
      this.#dispatchChange();
    }
    #isChoice(value) {
      return this.choices.some((choice) => choice.value === value);
    }
    #labelFor(value) {
      return this.choices.find((choice) => choice.value === value)?.label ?? value;
    }
    // A chip requested a checked-state toggle (click, Enter, or Space).
    #onChipToggle = (event) => {
      const { value } = event.detail;
      const checked = new Set(this.checked);
      if (checked.has(value)) {
        checked.delete(value);
        this._announcement = `${this.#labelFor(value)} unchecked`;
      } else {
        checked.add(value);
        this._announcement = `${this.#labelFor(value)} checked`;
      }
      this.checked = this.choices.map((choice) => choice.value).filter((choiceValue) => checked.has(choiceValue));
      this.#dispatchChange();
    };
    #dispatchChange() {
      void this.updateComplete.then(() => {
        this.dispatchEvent(
          new CustomEvent("bsides-chip-group:change", { bubbles: true })
        );
      });
    }
  };
  customElements.define("bsides-chip-group", BsidesChipGroup);

  // srcts/src/components/inputChipGroup.ts
  var ChipGroupInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, "bsides-chip-group");
    }
    getValue(el) {
      return el.checked;
    }
    // Matches the input handler registered by the R side (empty selection
    // becomes NULL).
    getType(el) {
      void el;
      return "bsides.chipgroup";
    }
    subscribe(el, callback) {
      this.listen(el, "bsides-chip-group:change", () => {
        callback(false);
      });
    }
    // All state changes live in the component; the binding only forwards.
    receiveMessage(el, data) {
      el.receiveUpdate(data);
    }
  };
  registerBinding(ChipGroupInputBinding, "chipgroup");

  // node_modules/lit-html/directives/if-defined.js
  var o5 = (o6) => o6 ?? A;

  // srcts/src/components/upload.ts
  var UPLOAD_CONCURRENCY = 4;
  function slotId(inputId, index) {
    return `${inputId}__bsides_slot_${index + 1}`;
  }
  var FileError = class extends Error {
    file;
    constructor(file, cause) {
      super(messageOf(cause));
      this.file = file;
    }
  };
  function fileOf(error) {
    return error instanceof FileError ? error.file : void 0;
  }
  var Uploader = class {
    #inputId;
    #files;
    #callbacks;
    #totalBytes;
    #loaded;
    #shinyapp = null;
    #inflight = /* @__PURE__ */ new Set();
    #closes = [];
    #aborted = false;
    #finished = false;
    constructor(options) {
      const { inputId, files, ...callbacks } = options;
      this.#inputId = inputId;
      this.#files = files;
      this.#callbacks = callbacks;
      this.#totalBytes = files.reduce((total, file) => total + file.size, 0);
      this.#loaded = files.map(() => 0);
    }
    // The batch payload carries this, not the slot names: the server
    // derives `<id>__bsides_slot_<i>` itself rather than dereferencing
    // strings off the wire.
    get count() {
      return this.#files.length;
    }
    // Runs the whole batch. Resolves once the batch has ended for any
    // reason — completion, error, or cancellation; callers observe which
    // through the callbacks.
    async run() {
      const shinyapp = window.Shiny?.shinyapp;
      if (!shinyapp?.isConnected()) {
        this.#fail("Not connected to the server.");
        return;
      }
      this.#shinyapp = shinyapp;
      if (this.#files.length === 0) {
        this.#finish();
        return;
      }
      this.#progress(null, 0, 0);
      let jobs;
      try {
        jobs = await Promise.all(
          this.#files.map((file) => this.#uploadInit(file))
        );
      } catch (error) {
        this.#fail(messageOf(error), fileOf(error));
        return;
      }
      if (this.#isStopped()) {
        return;
      }
      await this.#transferAll(jobs);
      if (this.#isStopped()) {
        return;
      }
      await Promise.all(this.#closes);
      if (this.#isStopped()) {
        return;
      }
      this.#progress(null, 0, 1);
      this.#finish();
    }
    // Un-ended jobs are orphaned server-side; the session cleans them and
    // their temp files up.
    cancel() {
      if (this.#finished) {
        return;
      }
      this.#finished = true;
      this.#stop();
    }
    async #transferAll(jobs) {
      let next = 0;
      const worker = async () => {
        for (; ; ) {
          const index = next++;
          if (index >= this.#files.length || this.#isStopped()) {
            return;
          }
          try {
            await this.#transfer(jobs[index], this.#files[index], index);
          } catch (error) {
            this.#fail(messageOf(error), fileOf(error));
            return;
          }
        }
      };
      const workers = Math.min(UPLOAD_CONCURRENCY, this.#files.length);
      await Promise.all(Array.from({ length: workers }, () => worker()));
    }
    // Holds the pool slot for the POST alone. The job close is started
    // here and left to settle on its own, so the worker takes the next
    // queued file while the server is still closing this one's job — the
    // close is answered on R's single thread, which during a batch is also
    // ingesting every other in-flight body.
    async #transfer(job, file, index) {
      this.#progress(file, this.#loaded[index], this.#fraction());
      try {
        await this.#post(job.uploadUrl, file, index);
      } catch (error) {
        throw new FileError(file, error);
      }
      if (this.#isStopped()) {
        return;
      }
      this.#loaded[index] = file.size;
      this.#progress(file, this.#loaded[index], this.#fraction());
      this.#closes.push(this.#close(job.jobId, file, index));
    }
    // A file's job close, detached from the slot its POST held. Reports
    // its own failure instead of rejecting: these are joined with
    // `Promise.all`, where a rejection would be held behind any sibling
    // close that never settles.
    async #close(jobId, file, index) {
      try {
        await this.#uploadEnd(jobId, slotId(this.#inputId, index));
      } catch (error) {
        this.#fail(messageOf(error), file);
        return;
      }
      if (this.#isStopped()) {
        return;
      }
      this.#callbacks.onFileDone?.(file);
    }
    #uploadInit(file) {
      const info = [{ name: file.name, size: file.size, type: file.type }];
      return this.#request("uploadInit", [info]).catch((error) => {
        throw new FileError(file, error);
      });
    }
    #uploadEnd(jobId, slot) {
      return this.#request("uploadEnd", [jobId, slot]);
    }
    // Only reachable after run() has stored the connected app.
    #request(method, args) {
      const shinyapp = this.#shinyapp;
      if (!shinyapp) {
        return Promise.reject(new Error("Not connected to the server."));
      }
      return new Promise((resolve, reject) => {
        shinyapp.makeRequest(
          method,
          args,
          resolve,
          (error) => reject(new Error(error)),
          void 0
        );
      });
    }
    #post(url, file, index) {
      return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        this.#inflight.add(xhr);
        xhr.open("POST", url, true);
        xhr.setRequestHeader("Content-Type", "application/octet-stream");
        xhr.upload.onprogress = (event) => {
          if (event.lengthComputable) {
            this.#loaded[index] = Math.max(this.#loaded[index], event.loaded);
            this.#progress(file, this.#loaded[index], this.#fraction());
          }
        };
        xhr.onload = () => {
          this.#inflight.delete(xhr);
          if (xhr.status >= 200 && xhr.status < 300) {
            resolve();
          } else {
            reject(
              new Error(xhr.responseText || `Upload failed (${xhr.status})`)
            );
          }
        };
        xhr.onerror = () => {
          this.#inflight.delete(xhr);
          reject(new Error("Upload failed."));
        };
        xhr.onabort = () => {
          this.#inflight.delete(xhr);
          resolve();
        };
        xhr.send(file);
      });
    }
    // Clears the wire only. Job closes already in flight cannot be
    // recalled — Shiny has no abort for a request — so a stopped batch can
    // still set every slot it declared. What keeps it from delivering is
    // run()'s stopped check before it finishes: no payload is sent, so
    // nothing reads them.
    #stop() {
      this.#aborted = true;
      const requests = [...this.#inflight];
      this.#inflight.clear();
      for (const xhr of requests) {
        xhr.abort();
      }
    }
    // Read through a call, not the field: a cancel or a sibling's failure
    // lands between the awaits in the transfer chains, which control-flow
    // narrowing of a plain field read cannot account for.
    #isStopped() {
      return this.#aborted;
    }
    // The batch fraction. Monotone by construction rather than by clamping
    // here: every counter it sums is held at its own high-water mark, and a
    // sum of counters that never fall cannot fall either.
    #fraction() {
      if (this.#totalBytes <= 0) {
        return 0;
      }
      const sent = this.#loaded.reduce((total, bytes) => total + bytes, 0);
      return sent / this.#totalBytes;
    }
    #progress(file, loaded, batch) {
      if (this.#isStopped()) {
        return;
      }
      this.#callbacks.onProgress?.({
        file,
        loaded,
        batch: Math.min(Math.max(batch, 0), 1)
      });
    }
    #fail(message, file) {
      if (this.#finished) {
        return;
      }
      this.#finished = true;
      this.#stop();
      this.#callbacks.onError?.(message, file);
    }
    #finish() {
      if (this.#finished) {
        return;
      }
      this.#finished = true;
      this.#callbacks.onDone?.();
    }
  };
  function messageOf(error) {
    if (error instanceof Error) {
      return error.message || "Upload failed.";
    }
    return typeof error === "string" && error ? error : "Upload failed.";
  }

  // srcts/src/components/fileValidate.ts
  function matchesToken(file, token) {
    const type = file.type.toLowerCase();
    if (token.startsWith(".")) {
      return file.name.toLowerCase().endsWith(token);
    }
    if (type === "") {
      return false;
    }
    if (token.endsWith("/*")) {
      return type.startsWith(token.slice(0, -1));
    }
    return type === token;
  }
  function isAccepted(file, accept) {
    const tokens = accept.split(",").map((token) => token.trim().toLowerCase()).filter((token) => token !== "");
    if (tokens.length === 0) {
      return true;
    }
    return tokens.some((token) => matchesToken(file, token));
  }
  function validateFiles(files, options) {
    const accepted = [];
    const rejected = [];
    for (const file of files) {
      if (options.maxSize !== null && file.size > options.maxSize) {
        rejected.push({
          name: file.name,
          reason: { kind: "size", limit: options.maxSize }
        });
        continue;
      }
      if (!isAccepted(file, options.accept)) {
        rejected.push({ name: file.name, reason: { kind: "accept" } });
        continue;
      }
      accepted.push(file);
    }
    return { accepted, rejected };
  }

  // srcts/src/components/webcomponents/file.ts
  var BsidesFile = class extends i4 {
    static properties = {
      multiple: { type: Boolean, reflect: true },
      accept: { type: String, reflect: true },
      capture: { type: String, reflect: true },
      mode: { type: String, reflect: true },
      button: { type: String, reflect: true },
      placeholder: { type: String },
      summary: { type: String },
      disabled: { type: Boolean, reflect: true },
      max: { type: Number },
      maxSize: { type: Number, attribute: "data-max-size" },
      _items: { state: true },
      _listOpen: { state: true },
      _failure: { state: true },
      _dragover: { state: true },
      _announcement: { state: true },
      _batch: { state: true },
      _phase: { state: true }
    };
    // The batch in flight, if any. One at a time: a new selection cancels
    // and restarts, matching "the selection is the value" semantics.
    #uploader = null;
    // dragenter/dragleave fire for every descendant a drag crosses, so the
    // hover state counts entries rather than trusting a single leave.
    #dragDepth = 0;
    // The form ancestor being listened to for bsides-form:submit, held so
    // disconnection can unhook exactly what connection hooked.
    #form = null;
    // The batch in flight, as a promise a form can await. Uploader.run()
    // resolves for every ending — completion, error, cancellation — so
    // success is only distinguishable through the callbacks, which settle
    // this instead. Held on the instance because it is created in
    // #start(), settled from those callbacks, and read by #onFormSubmit().
    #batchPromise = null;
    #batchSettle = null;
    // Trailing-edge throttle for the progress companion — progress events
    // fire per XHR tick, far faster than the server wants them.
    #progressPending = 0;
    #progressTimer = null;
    constructor() {
      super();
      this.multiple = false;
      this.accept = "";
      this.capture = "";
      this.mode = "auto";
      this.button = "show";
      this.placeholder = "Choose a file";
      this.summary = "{files} \xB7 {size}";
      this.disabled = false;
      this.max = null;
      this.maxSize = null;
      this._items = [];
      this._listOpen = true;
      this._failure = null;
      this._dragover = false;
      this._announcement = "";
      this._batch = 0;
      this._phase = "idle";
    }
    createRenderRoot() {
      return this;
    }
    // A staged set inside input_form() uploads on the form's submit,
    // landing the value alongside the replayed frozen values. The hook is
    // the form binding's bsides-form:submit event; the guards in
    // #onUpload() make this a no-op outside manual mode or with nothing
    // staged.
    connectedCallback() {
      super.connectedCallback();
      this.#form = this.closest("form");
      this.#form?.addEventListener("bsides-form:submit", this.#onFormSubmit);
    }
    disconnectedCallback() {
      super.disconnectedCallback();
      this.#form?.removeEventListener("bsides-form:submit", this.#onFormSubmit);
      this.#form = null;
      this.#uploader?.cancel();
      this.#uploader = null;
    }
    #onFormSubmit = (event) => {
      this.#onUpload();
      if (this.#batchPromise) {
        event.detail.waitUntil(
          this.#batchPromise
        );
      }
    };
    // Shiny's client drops a setInputValue whose value repeats the last one
    // sent under that name; without this the same set uploaded twice in a
    // row would deliver only once.
    #batchSeq = 0;
    // R's `bsides.file.batch` handler rebuilds the slot names from `n` and
    // rbinds those inputs in position order, so input$<id> is set once, in
    // declared order.
    #pushBatch(n4) {
      if (!this.id || n4 === 0) {
        return;
      }
      this.#batchSeq += 1;
      window.Shiny?.setInputValue?.(`${this.id}:bsides.file.batch`, {
        seq: this.#batchSeq,
        n: n4
      });
    }
    #openBatch() {
      this.#batchPromise = new Promise((resolve, reject) => {
        this.#batchSettle = { resolve, reject };
      });
      void this.#batchPromise.catch(() => void 0);
    }
    #settleBatch(failure) {
      const settle = this.#batchSettle;
      this.#batchSettle = null;
      this.#batchPromise = null;
      if (!settle) {
        return;
      }
      if (failure) {
        settle.reject(failure);
      } else {
        settle.resolve();
      }
    }
    // Render guards and gesture checks need only the boolean.
    get #uploading() {
      return this._phase === "uploading";
    }
    render() {
      return b2`
      <div
        class="file-dropzone${this._dragover ? " dragover" : ""}${this.#atMax() ? " at-max" : ""}"
        @click=${this.#onDropzoneClick}
        @dragenter=${this.#onDragEnter}
        @dragover=${this.#onDragOver}
        @dragleave=${this.#onDragLeave}
        @drop=${this.#onDrop}
        @paste=${this.#onPaste}
      >
        <input
          type="file"
          class="file-input"
          ?multiple=${this.multiple}
          accept=${o5(this.accept || void 0)}
          capture=${o5(this.capture || void 0)}
          ?disabled=${this.disabled || this.#uploading || this.#atMax()}
          data-shiny-no-bind-input
          @change=${this.#onChange}
        />
        <span class="file-prompt">${this.#promptText()}</span>
      </div>
      ${this.#renderBatch()} ${this.#renderList()}
      <p class="file-errors" role="alert">
        ${this.#failureMessages().map(
        (message) => b2`<span class="file-error">${message}</span>`
      )}
      </p>
      <span class="visually-hidden" aria-live="polite"
        >${this._announcement}</span
      >
    `;
    }
    #renderList() {
      if (this._items.length === 0) {
        return A;
      }
      const perFile = this._items.length > 1;
      const count = this._items.length;
      const total = this._items.reduce((sum, item) => sum + item.file.size, 0);
      const summaryText = interpolate(this.summary, {
        n: String(count),
        files: count === 1 ? "1 file" : `${count} files`,
        size: formatSize(total),
        done: String(this._items.filter((item) => item.status === "done").length),
        failed: String(
          this._items.filter((item) => item.status === "error").length
        ),
        percent: String(Math.round(this._batch * 100))
      });
      return b2`
      <details
        class="file-disclosure"
        ?open=${this._listOpen}
        @toggle=${this.#onListToggle}
      >
        <summary class="file-summary">${summaryText}</summary>
        <ul class="file-list" role="list">
          ${c4(
        this._items,
        (item) => item.file,
        (item) => b2`
            <li class="file-item ${item.status}">
              <span class="file-item-name">${item.file.name}</span>
              <span class="file-item-size">${formatSize(item.file.size)}</span>
              ${this.#removable(item) ? b2`<button
                      type="button"
                      class="file-item-remove btn-close"
                      aria-label="Remove ${item.file.name}"
                      @click=${() => this.#onRemove(item)}
                    ></button>` : A}
              ${perFile ? this.#renderProgress(
          "file-item-progress",
          item.progress,
          `${item.file.name} upload progress`
        ) : A}
            </li>
            `
      )}
        </ul>
      </details>
    `;
    }
    // Batch controls: progress and Cancel while a batch is in flight. In
    // manual mode the row is permanent — the Upload button, disabled until
    // something is staged, is the affordance that says a second action is
    // coming. Auto mode at rest renders nothing, as before.
    #renderBatch() {
      if (this.#uploading) {
        return b2`
        <div class="file-batch">
          ${this.#renderProgress(
          "file-batch-progress",
          this._batch,
          "Upload progress"
        )}
          <button
            type="button"
            class="btn btn-danger btn-sm file-cancel"
            @click=${this.#onCancel}
          >
            Cancel
          </button>
        </div>
      `;
      }
      if (this.mode !== "manual" || this.button === "none") {
        return A;
      }
      return b2`
      <div class="file-batch">
        <button
          type="button"
          class="btn btn-primary btn-sm file-upload"
          ?disabled=${this.disabled || this.#stagedFiles().length === 0}
          @click=${this.#onUpload}
        >
          Upload
        </button>
      </div>
    `;
    }
    // Progress as an inline custom property rather than a nested bar with a
    // width: the markup stays flat and the SCSS owns the visual.
    #renderProgress(className, fraction, label) {
      const percent = Math.round(fraction * 100);
      return b2`<span
      class=${className}
      role="progressbar"
      aria-label=${label}
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow=${percent}
      style="--bsides-file-progress: ${percent}%"
    ></span>`;
    }
    // Apply a server update (update_file() → receiveMessage() → here).
    receiveUpdate(msg) {
      if (msg.reset === true) {
        this.#reset();
      }
      if (msg.accept !== void 0) {
        this.accept = msg.accept;
      }
      if (msg.placeholder !== void 0) {
        this.placeholder = msg.placeholder;
      }
      if (msg.summary !== void 0) {
        this.summary = msg.summary;
      }
      if (msg.upload_start === true) {
        this.#onUpload();
      }
      if (msg.upload_cancel === true) {
        this.#onCancel();
      }
      if (msg.enable === true) {
        this.disabled = false;
      }
      if (msg.disable === true) {
        this.disabled = true;
      }
    }
    get #inputElement() {
      return this.querySelector(".file-input");
    }
    // The dropzone forwards clicks to the real input. Clicks landing on the
    // input itself already open the picker; forwarding them would open it
    // twice.
    #onDropzoneClick = (event) => {
      if (this.disabled || this.#uploading || this.#atMax()) {
        return;
      }
      if (event.target !== this.#inputElement) {
        this.#inputElement?.click();
      }
    };
    #onChange = (event) => {
      const input = event.target;
      const files = Array.from(input.files ?? []);
      input.value = "";
      if (files.length > 0) {
        this.upload(files);
      }
    };
    // Deliberately blind to the cap: a drop or paste at max must still
    // reach upload(), where the gesture is rejected with a reason the
    // user can read, rather than be dropped on the floor here.
    #acceptsFiles() {
      return !this.disabled && !this.#uploading;
    }
    // The staged set is full. Prevention, manual mode only — auto mode
    // has no accumulating set, so its cap is the gesture check in
    // upload(). Done rows do not count: delivered and undeletable, they
    // are not part of the next batch, and counting them would leave a
    // full set nothing but reset_file() could reopen.
    #atMax() {
      return this.mode === "manual" && this.max != null && this.#stagedFiles().length >= this.max;
    }
    #promptText() {
      if (this.#atMax()) {
        return `Limit of ${fileCount(this.max ?? 0)} reached \u2014 remove one to add more`;
      }
      return this.placeholder;
    }
    // The cap bounds what the next batch may contain. In manual mode the
    // staged rows count and a same-named file replaces rather than adds;
    // a single-file input replaces its whole set, so only the gesture
    // counts there, as in auto mode.
    #countExceeded(files, max) {
      if (this.mode !== "manual" || !this.multiple) {
        return files.length > max;
      }
      const staged = new Set(this.#stagedFiles().map((file) => file.name));
      const additions = files.filter((file) => !staged.has(file.name)).length;
      return staged.size + additions > max;
    }
    #onDragEnter = (event) => {
      if (!this.#acceptsFiles()) {
        return;
      }
      event.preventDefault();
      this.#dragDepth++;
      this._dragover = true;
    };
    #onDragOver = (event) => {
      if (!this.#acceptsFiles()) {
        return;
      }
      event.preventDefault();
      if (event.dataTransfer) {
        event.dataTransfer.dropEffect = "copy";
      }
    };
    #onDragLeave = () => {
      this.#dragDepth = Math.max(this.#dragDepth - 1, 0);
      if (this.#dragDepth === 0) {
        this._dragover = false;
      }
    };
    #onDrop = (event) => {
      if (!this.#acceptsFiles()) {
        return;
      }
      event.preventDefault();
      this.#dragDepth = 0;
      this._dragover = false;
      if (!event.dataTransfer) {
        return;
      }
      const { files, directories } = readTransfer(event.dataTransfer);
      if (files.length === 0 && directories.length === 0) {
        return;
      }
      this.upload(
        files,
        directories.map((name) => ({
          name,
          reason: { kind: "directory" }
        }))
      );
    };
    // Pasting a screenshot is a file drop by another route; jsdom aside,
    // clipboardData.files carries it.
    #onPaste = (event) => {
      if (!this.#acceptsFiles()) {
        return;
      }
      const files = Array.from(event.clipboardData?.files ?? []);
      if (files.length === 0) {
        return;
      }
      event.preventDefault();
      this.upload(files);
    };
    // <details open> is DOM state; bind it to _listOpen and sync back here
    // so a mid-upload re-render cannot clobber a user's fold.
    #onListToggle = (event) => {
      this._listOpen = event.target.open;
    };
    // Abandons the batch in flight — the Cancel button and
    // file_upload_cancel() alike, hence the guard. In manual mode every
    // row returns to pending: nothing failed, the set is still staged,
    // and the retry re-POSTs from the first byte, so progress goes back
    // to 0 with the status. Auto mode marks non-done rows as failed, as
    // before — it has no staged set to return to.
    #onCancel = () => {
      if (!this.#uploading) {
        return;
      }
      this.#uploader?.cancel();
      this.#uploader = null;
      this.#settleBatch(new Error("Upload cancelled."));
      this._phase = this.mode === "manual" ? "staged" : "cancelled";
      this.#pushProgressFinal(0);
      this._items = this._items.map((item) => {
        if (this.mode === "manual") {
          return { ...item, status: "pending", progress: 0 };
        }
        return item.status === "done" ? item : { ...item, status: "error" };
      });
      this.#announce("Upload cancelled");
    };
    // The single entry for every gesture (pick, drop, paste): validates a
    // set of files and hands the survivors to the mode's terminal — started
    // as a batch in auto mode, *staged without uploading* in manual mode,
    // the name notwithstanding. Files arriving by drop or paste never
    // passed the picker's own filtering, so `accept` and `multiple` are
    // enforced here as well as by the picker.
    //
    // `rejected` carries checks the caller already made — dropped folders,
    // which only a DataTransfer can identify.
    upload(files, rejected = []) {
      const rejections = [...rejected];
      if (!this.multiple && files.length > 1) {
        rejections.push(
          ...files.map((file) => ({
            name: file.name,
            reason: { kind: "multiple" }
          }))
        );
        this.#reject(rejections);
        return;
      }
      const validation = validateFiles(files, {
        accept: this.accept,
        maxSize: this.maxSize
      });
      rejections.push(...validation.rejected);
      if (validation.accepted.length === 0) {
        this.#reject(rejections);
        return;
      }
      if (this.max != null && this.#countExceeded(validation.accepted, this.max)) {
        rejections.push(
          ...validation.accepted.map((file) => ({
            name: file.name,
            reason: { kind: "count", limit: this.max }
          }))
        );
        this.#reject(rejections);
        return;
      }
      if (this.mode === "manual") {
        this.#stage(validation.accepted);
      } else {
        this.#start(validation.accepted);
      }
      this._failure = rejections.length > 0 ? { kind: "rejection", rejections } : null;
    }
    // Reports a gesture that staged or started nothing. In manual mode
    // the staged set survives — the set being built is not the thing that
    // failed — and the phase stays where it was: nothing was attempted,
    // so "failed" would be a lie.
    #reject(rejections) {
      this._failure = { kind: "rejection", rejections };
      if (this.mode !== "manual") {
        this._items = [];
        this._phase = "idle";
      }
      this.#announce(this.#failureMessages().join(" "));
    }
    // Adds validated files to the staged set — upload()'s manual-mode
    // terminal. A delivered batch's rows clear on the next addition: that
    // batch's value was set at uploadEnd, and keeping its rows would
    // conflate two batches in one list. A cancelled or failed batch
    // delivered nothing, leaves no done rows, and so survives additions.
    #stage(files) {
      this._failure = null;
      let items = this._items.some((item) => item.status === "done") ? [] : this._items;
      items = items.map(
        (item) => item.status === "error" ? { ...item, status: "pending" } : item
      );
      if (!this.multiple) {
        items = [];
      }
      const added = [];
      const replaced = [];
      for (const file of files) {
        const index = items.findIndex((item2) => item2.file.name === file.name);
        const item = { file, status: "pending", progress: 0 };
        if (index >= 0) {
          items = items.map((other, i7) => i7 === index ? item : other);
          replaced.push(file.name);
        } else {
          items = [...items, item];
          added.push(file.name);
        }
      }
      this._items = items;
      this._listOpen = true;
      this._phase = "staged";
      const count = this._items.length;
      const staged = count === 1 ? "1 file staged" : `${count} files staged`;
      const parts = [
        added.length === 1 ? `${added[0]} added` : "",
        added.length > 1 ? `${added.length} files added` : "",
        replaced.length === 1 ? `${replaced[0]} replaced` : "",
        replaced.length > 1 ? `${replaced.length} files replaced` : ""
      ].filter(Boolean);
      this.#announce(`${parts.join(", ")}, ${staged}`);
    }
    // The set a manual-mode batch would send: staged rows plus any
    // carrying a failure mark from the last attempt — a retry re-sends
    // everything.
    #stagedFiles() {
      return this._items.filter((item) => item.status === "pending" || item.status === "error").map((item) => item.file);
    }
    // A row can be removed while the user can still act on it: staged
    // (pending) or carrying a failure mark, with no batch in flight. A
    // done row was delivered at uploadEnd; removing it would not unsend
    // it.
    #removable(item) {
      return this.mode === "manual" && !this.#uploading && (item.status === "pending" || item.status === "error");
    }
    #onRemove(item) {
      const index = this._items.indexOf(item);
      this._items = this._items.filter((other) => other !== item).map(
        (other) => other.status === "error" ? { ...other, status: "pending" } : other
      );
      this._failure = null;
      this._phase = this._items.length === 0 ? "idle" : "staged";
      this.#announce(`${item.file.name} removed`);
      void this.updateComplete.then(() => {
        const controls = [
          ...this.querySelectorAll(".file-item-remove")
        ];
        const target = controls.at(index) ?? controls.at(index - 1) ?? this.#inputElement;
        target?.focus();
      });
    }
    // The Upload button, and the retry entry after a cancel or a failure.
    #onUpload = () => {
      const files = this.#stagedFiles();
      if (this.mode !== "manual" || files.length === 0 || this.#uploading) {
        return;
      }
      this.#start(files);
    };
    #start(files) {
      this.#uploader?.cancel();
      this.#settleBatch(new Error("Upload restarted."));
      this.#openBatch();
      this._failure = null;
      this.#pushProgressFinal(0);
      this._batch = 0;
      this._phase = "uploading";
      this._listOpen = true;
      this._items = files.map((file) => ({
        file,
        status: "pending",
        progress: 0
      }));
      this.#announce(
        files.length === 1 ? `Uploading ${files[0].name}` : `Uploading ${files.length} files`
      );
      const uploader = new Uploader({
        inputId: this.id,
        files,
        onProgress: ({ file, loaded, batch }) => {
          this._batch = batch;
          if (file) {
            this.#updateItem(file, {
              status: "uploading",
              progress: file.size > 0 ? loaded / file.size : 1
            });
          }
          this.dispatchEvent(
            new CustomEvent("bsides-file:progress", {
              bubbles: true,
              detail: { file, loaded, batch }
            })
          );
          this.#pushProgress(batch);
        },
        onFileDone: (file) => {
          this.#updateItem(file, { status: "done", progress: 1 });
        },
        // In manual mode a failure lands where a cancel lands: no payload
        // was sent, so the set is still the value. The failed file's
        // siblings were aborted, not at fault, so only it keeps a mark;
        // a batch-level failure names no file and marks no row. Auto mode
        // keeps its terminal marking.
        onError: (message, failed) => {
          this.#uploader = null;
          this.#settleBatch(new Error(message));
          this._phase = "failed";
          this._failure = { kind: "failure", message };
          this.#pushProgressFinal(0);
          this._items = this._items.map((item) => {
            if (this.mode === "manual") {
              const status = item.file === failed ? "error" : "pending";
              return { ...item, status, progress: 0 };
            }
            return item.status === "done" ? item : { ...item, status: "error" };
          });
          this.#announce(message);
        },
        onDone: () => {
          this.#uploader = null;
          this.#pushBatch(uploader.count);
          this.#settleBatch();
          this._phase = "done";
          this._batch = 1;
          this.#pushProgressFinal(1);
          this.#announce(
            files.length === 1 ? `${files[0].name} uploaded` : `${files.length} files uploaded`
          );
        }
      });
      this.#uploader = uploader;
      void uploader.run();
    }
    #updateItem(file, changes) {
      this._items = this._items.map(
        (item) => item.file === file ? { ...item, ...changes } : item
      );
    }
    #reset() {
      this.#uploader?.cancel();
      this.#uploader = null;
      this.#settleBatch(new Error("Upload reset."));
      this.#pushProgressFinal(0);
      this._items = [];
      this._listOpen = true;
      this._failure = null;
      this._dragover = false;
      this._batch = 0;
      this._phase = "idle";
      const input = this.#inputElement;
      if (input) {
        input.value = "";
      }
    }
    #announce(message) {
      this._announcement = message;
    }
    // Marks the whole component busy while bytes are in transit. Set on the
    // host, which render() cannot reach: this element renders into light DOM
    // and so owns its children, not its own attributes.
    //
    // Also the single choke point for the status/staged/error companion
    // inputs: every state change lands here once per render, so the
    // pushes cannot drift from what the user sees. Shiny's send-side
    // dedupe drops repeats, and progress pushes separately (throttled)
    // from onProgress.
    updated(changed) {
      if (changed.has("_phase")) {
        if (this.#uploading) {
          this.setAttribute("aria-busy", "true");
        } else {
          this.removeAttribute("aria-busy");
        }
      }
      this.#push("status", this._phase);
      this.#push(
        "staged:bsides.file.staged",
        this.mode === "manual" ? this.#stagedFiles().map((file) => ({
          name: file.name,
          size: file.size,
          type: file.type
        })) : []
      );
      this.#push("error:bsides.file.error", this.#failurePayload());
    }
    // The rendered sentences — the .file-errors list and the condition's
    // message, from one source. Gesture-level rejections repeat one
    // sentence across their files; the display collapses the duplicates
    // while the records stay per-file.
    #failureMessages() {
      if (this._failure === null) {
        return [];
      }
      if (this._failure.kind === "failure") {
        return [this._failure.message];
      }
      return [...new Set(this._failure.rejections.map(rejectionMessage))];
    }
    // The error companion's payload, turned into a condition object by
    // the bsides.file.error input handler: kind picks the condition's
    // class, messages its message, files its per-file record frame —
    // empty when the failure names no file.
    #failurePayload() {
      if (this._failure === null) {
        return null;
      }
      const files = this._failure.kind === "rejection" ? this._failure.rejections.map((rejection) => ({
        name: rejection.name,
        reason: rejection.reason.kind,
        limit: "limit" in rejection.reason ? rejection.reason.limit : null
      })) : [];
      return {
        kind: this._failure.kind,
        messages: this.#failureMessages(),
        files
      };
    }
    #push(suffix, value) {
      if (this.id) {
        window.Shiny?.setInputValue?.(`${this.id}__bsides_${suffix}`, value);
      }
    }
    #pushProgress(fraction) {
      this.#progressPending = fraction;
      if (this.#progressTimer === null) {
        this.#progressTimer = window.setTimeout(() => {
          this.#progressTimer = null;
          this.#push("progress", this.#progressPending);
        }, 150);
      }
    }
    // A batch ended: the throttle stops waiting and the final value —
    // 1 delivered, 0 abandoned — goes out immediately.
    #pushProgressFinal(fraction) {
      if (this.#progressTimer !== null) {
        window.clearTimeout(this.#progressTimer);
        this.#progressTimer = null;
      }
      this.#push("progress", fraction);
    }
  };
  function interpolate(template, vars) {
    return template.replace(
      /\{([a-z_]+)\}/g,
      (match, key) => key in vars ? vars[key] : match
    );
  }
  function readTransfer(transfer) {
    const files = [];
    const directories = [];
    for (const item of Array.from(transfer.items)) {
      if (item.kind !== "file") {
        continue;
      }
      const entry = item.webkitGetAsEntry();
      if (entry?.isDirectory) {
        directories.push(entry.name);
        continue;
      }
      const file = item.getAsFile();
      if (file) {
        files.push(file);
      }
    }
    return { files, directories };
  }
  function rejectionMessage(rejection) {
    switch (rejection.reason.kind) {
      case "size":
        return `${rejection.name} is larger than the ${formatSize(
          rejection.reason.limit
        )} upload limit.`;
      case "accept":
        return `${rejection.name} is not an accepted file type.`;
      case "directory":
        return `${rejection.name} is a folder, and folders cannot be uploaded.`;
      case "multiple":
        return "Only one file may be uploaded.";
      case "count":
        return `At most ${fileCount(rejection.reason.limit)} may be uploaded.`;
    }
  }
  function fileCount(n4) {
    return n4 === 1 ? "1 file" : `${n4} files`;
  }
  function formatSize(bytes) {
    const units = ["B", "kB", "MB", "GB", "TB"];
    let size = bytes;
    let unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size = size / 1024;
      unit++;
    }
    const rounded = unit === 0 ? size : Math.round(size * 10) / 10;
    return `${rounded} ${units[unit]}`;
  }
  customElements.define("bsides-file", BsidesFile);

  // srcts/src/components/inputFile.ts
  var FileInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, "bsides-file");
    }
    getValue(el) {
      void el;
      return null;
    }
    getType(el) {
      void el;
      return "shiny.file";
    }
    // Nothing to subscribe to: uploads reach the server over HTTP and are
    // announced by the protocol's uploadEnd, not by an input change.
    subscribe(el, callback) {
      void el;
      void callback;
    }
    // All state changes live in the component; the binding only forwards.
    receiveMessage(el, data) {
      el.receiveUpdate(data);
    }
  };
  registerBinding(FileInputBinding, "file");

  // srcts/src/components/inputForm.ts
  var formValues = /* @__PURE__ */ new WeakMap();
  var FormInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-form");
    }
    getValue(el) {
      return formValues.get(el);
    }
    subscribe(el, callback) {
      const inputValues = /* @__PURE__ */ new Map();
      window.jQuery?.(el).on("shiny:inputchanged.bsidesFormInputBinding", (event) => {
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
      this.listenDelegated(
        el,
        "click",
        ".bsides-input-form-submit",
        (event, submit) => {
          event.preventDefault();
          const button = submit;
          const blockers = [];
          el.dispatchEvent(
            new CustomEvent("bsides-form:submit", {
              bubbles: true,
              detail: {
                waitUntil: (blocker) => {
                  blockers.push(blocker);
                }
              }
            })
          );
          const send = () => {
            for (const [key, value] of inputValues.entries()) {
              Shiny?.setInputValue?.(key, value, { priority: "event" });
            }
            formValues.set(el, button.value);
            callback(false);
          };
          if (blockers.length === 0) {
            send();
            return;
          }
          const release = holdSubmits(el, button);
          void Promise.all(blockers).then(
            () => {
              release();
              send();
            },
            () => {
              release();
            }
          );
        }
      );
    }
    unsubscribe(el) {
      super.unsubscribe(el);
      window.jQuery?.(el).off(".bsidesFormInputBinding");
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "submit")) {
        const submits = el.querySelectorAll(
          ".bsides-input-form-submit"
        );
        [...submits].find((submit) => submit.value === data.submit)?.click();
      }
    }
  };
  function holdSubmits(el, button) {
    const held = [
      ...el.querySelectorAll(".bsides-input-form-submit")
    ].filter((other) => !other.disabled);
    for (const other of held) {
      other.disabled = true;
    }
    button.classList.add("pending");
    button.setAttribute("aria-busy", "true");
    return () => {
      for (const other of held) {
        other.disabled = false;
      }
      button.classList.remove("pending");
      button.removeAttribute("aria-busy");
    };
  }
  registerBinding(FormInputBinding, "form");

  // srcts/src/components/inputLink.ts
  var clicks2 = /* @__PURE__ */ new WeakMap();
  var LinkInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-link");
    }
    getValue(el) {
      return clicks2.get(el) ?? 0;
    }
    // Matches the input handler registered by the R side.
    getType(el) {
      void el;
      return "bsides.link";
    }
    subscribe(el, callback) {
      this.listen(el, "click", () => {
        clicks2.set(el, this.getValue(el) + 1);
        callback(false);
      });
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
  var ListGroupInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-list-group");
    }
    getValue(el) {
      return [...el.querySelectorAll(".list-group-item-action.active")].map(
        (e5) => e5.getAttribute("data-bsides-value")
      );
    }
    subscribe(el, callback) {
      this.listenDelegated(el, "click", ".list-group-item-action", (_2, item) => {
        item.classList.toggle("active");
        callback(false);
      });
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const choices = el.querySelectorAll(
        ".list-group-item-action"
      );
      const valueOf = (e5) => e5.getAttribute("data-bsides-value") ?? "";
      if (hasDefinedProperty(data, "select")) {
        for (const choice of choices) {
          choice.classList.toggle(
            "active",
            data.select.includes(valueOf(choice))
          );
        }
      }
      if (hasDefinedProperty(data, "disable")) {
        for (const choice of choices) {
          const disable = data.disable.includes(valueOf(choice));
          choice.classList.toggle("disabled", disable);
          choice.disabled = disable;
        }
      }
      announce(el);
    }
  };
  registerBinding(ListGroupInputBinding, "listgroup");

  // srcts/src/components/inputMenu.ts
  var menuValues = /* @__PURE__ */ new WeakMap();
  var MenuInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-menu");
    }
    getValue(el) {
      return menuValues.get(el);
    }
    subscribe(el, callback) {
      this.listenDelegated(el, "click", ".dropdown-item", (_2, item) => {
        menuValues.set(el, item.value);
        callback(false);
      });
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "label")) {
        const toggle = el.querySelector(":scope > .dropdown-toggle");
        if (toggle) {
          toggle.innerHTML = data.label;
        }
      }
      if (hasDefinedProperty(data, "disable")) {
        const choices = el.querySelectorAll(".dropdown-item");
        for (const choice of choices) {
          const disable = data.disable.includes(choice.value);
          choice.disabled = disable;
          choice.classList.toggle("disabled", disable);
        }
      }
      if (hasDefinedProperty(data, "select")) {
        menuValues.set(el, data.select);
        announce(el);
      }
    }
  };
  registerBinding(MenuInputBinding, "menu");

  // srcts/src/components/webcomponents/multiSelect.ts
  var supportsPopover = typeof HTMLElement.prototype.showPopover === "function";
  var menuMaxHeight = 240;
  var menuSpacer = 2;
  var menuViewportGutter = 8;
  var BsidesMultiSelect = class extends i4 {
    static properties = {
      chips: { type: Array },
      choices: { type: Array },
      edit: { type: String, reflect: true },
      type: { type: String },
      layout: { type: String, reflect: true },
      max: { type: Number },
      placeholder: { type: String },
      disabled: { type: Boolean, reflect: true },
      label: { type: String },
      _announcement: { state: true },
      _open: { state: true },
      _query: { state: true },
      _activeIndex: { state: true }
    };
    // Fallback for aria-controls/aria-activedescendant ids when the element
    // itself has no id.
    #uid = `bsides-multi-select-${Math.random().toString(36).slice(2, 8)}`;
    // Whether the menu is currently shown as a top-layer popover. Tracked
    // here rather than via :popover-open so show/hide stay balanced even
    // when a close lands before the open's render round trip completes.
    #popoverShown = false;
    constructor() {
      super();
      this.chips = [];
      this.choices = [];
      this.edit = "choices";
      this.type = "primary";
      this.layout = "vertical";
      this.max = null;
      this.placeholder = "";
      this.disabled = false;
      this.label = "";
      this._announcement = "";
      this._open = false;
      this._query = "";
      this._activeIndex = -1;
      this.addEventListener("bsides-chip:remove", this.#onChipRemove);
    }
    createRenderRoot() {
      return this;
    }
    disconnectedCallback() {
      super.disconnectedCallback();
      document.removeEventListener("pointerdown", this.#onOutsidePointerdown);
      this.#removeViewportListeners();
      this.#popoverShown = false;
    }
    // Re-anchor an open top-layer menu after any re-render: chip changes
    // resize the field, which moves the menu's anchor point.
    updated() {
      if (this.#popoverShown) {
        this.#positionMenu();
      }
    }
    render() {
      return b2`
      <div class="multi-select-field" @mousedown=${this.#onFieldMousedown}>
        <div class="multi-select-field-content">
          <div
            class="multi-select-chips"
            role="group"
            aria-label=${this.label || "Selected values"}
          >
            ${c4(
        this.chips,
        (value) => value,
        (value) => {
          const chip = this.#chipFor(value);
          return b2`<bsides-chip
                  .value=${chip.value}
                  .label=${chip.label}
                  .type=${this.type}
                  removable
                  ?disabled=${this.disabled}
                ></bsides-chip>`;
        }
      )}
          </div>
          <input
            type="text"
            class="multi-select-input"
            placeholder=${o5(
        this.chips.length === 0 ? this.placeholder || void 0 : void 0
      )}
            ?disabled=${this.disabled || this.#atMax()}
            data-shiny-no-bind-input
            role=${o5(this.#comboboxAttr("combobox"))}
            aria-expanded=${o5(this.#comboboxAttr(String(this._open)))}
            aria-controls=${o5(this.#comboboxAttr(this.#menuId()))}
            aria-autocomplete=${o5(this.#comboboxAttr("list"))}
            aria-activedescendant=${o5(this.#activeOptionId())}
            @keydown=${this.#onKeydown}
            @input=${this.#onInput}
            @focus=${this.#onFocus}
            @blur=${this.#onBlur}
          />
        </div>
        ${this.#renderCaret()}
      </div>
      ${this.#renderMenu()}
      <span class="visually-hidden" aria-live="polite">
        ${this._announcement}
      </span>
    `;
    }
    // The dropdown indicator at the field's trailing edge. Decorative: its
    // clicks fall through to the field (pointer-events: none), which opens
    // the menu — open-only, never a toggle. Rendered outside
    // .multi-select-field-content so horizontal scrolling passes under it.
    #renderCaret() {
      if (!this.#hasMenu()) {
        return A;
      }
      return b2`<svg
      class="multi-select-caret${this._open ? " open" : ""}"
      viewBox="0 0 16 16"
      width="1em"
      height="1em"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      aria-hidden="true"
    >
      <path d="M4 6 8 10 12 6" />
    </svg>`;
    }
    // The filtering listbox: all choices, a checkmark beside current
    // members, selection toggles membership. Bootstrap's
    // .dropdown-menu/.dropdown-item CSS classes only — the dropdown plugin's
    // menu-button focus model doesn't fit a combobox, so visibility and
    // selection are handled here (see plan-multi-select-input.md).
    #renderMenu() {
      if (!this.#hasMenu()) {
        return A;
      }
      const options = this.#filteredChoices();
      return b2`
      <ul
        id=${this.#menuId()}
        class="dropdown-menu${this._open ? " show" : ""}"
        popover=${o5(supportsPopover ? "manual" : void 0)}
        role="listbox"
        aria-label="Options"
        @mousedown=${this.#onMenuMousedown}
      >
        ${options.length === 0 ? b2`<li><span class="dropdown-item disabled">No matches</span></li>` : options.map((choice, index) => {
        const member = this.chips.includes(choice.value);
        return b2`
                <li role="presentation">
                  <button
                    type="button"
                    id=${this.#optionId(index)}
                    class="dropdown-item${index === this._activeIndex ? " active" : ""}"
                    role="option"
                    aria-selected=${member ? "true" : "false"}
                    @click=${() => this.#toggleChoice(choice)}
                  >
                    ${member ? b2`<svg
                          class="option-check"
                          viewBox="0 0 16 16"
                          width="1em"
                          height="1em"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2.5"
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          aria-hidden="true"
                        >
                          <path d="M3 8.5 6.5 12 13 4.5" />
                        </svg>` : A}
                    ${choice.label}
                  </button>
                </li>
              `;
      })}
      </ul>
    `;
    }
    // Apply a server update (update_multi_select() → receiveMessage() →
    // here). All state changes stay inside the component; a change event is
    // dispatched afterwards so the binding reports the (possibly new) value.
    receiveUpdate(msg) {
      if (msg.choices !== void 0) {
        this.choices = msg.choices;
        if (this.edit !== "free") {
          this.chips = this.chips.filter((value) => this.#isChoice(value));
        }
      }
      if (msg.select !== void 0) {
        const select = Array.isArray(msg.select) ? msg.select : [msg.select];
        const known = this.edit === "free" ? select : select.filter((value) => this.#isChoice(value));
        if (known.length !== select.length) {
          console.warn(
            `bsides-multi-select: dropping value(s) not found in choices: ` + select.filter((value) => !this.#isChoice(value)).join(", ")
          );
        }
        this.chips = known;
      }
      if (msg.placeholder !== void 0) {
        this.placeholder = msg.placeholder;
      }
      if (msg.max !== void 0) {
        this.max = msg.max;
      }
      if (msg.enable === true) {
        this.disabled = false;
      }
      if (msg.disable === true) {
        this.disabled = true;
        this.#closeMenu();
      }
      this.#dispatchChange();
    }
    // There is a dropdown whenever the set is bounded by choices, or
    // choices exist to suggest at edit = "free" (the mixed mode). A free
    // input without choices is pure tag entry.
    #hasMenu() {
      return this.edit === "choices" || this.choices.length > 0;
    }
    #atMax() {
      return this.max != null && this.chips.length >= this.max;
    }
    #isChoice(value) {
      return this.choices.some((choice) => choice.value === value);
    }
    // The chip for a member value: its choice's label when one exists,
    // otherwise the value labels itself (free-created chips).
    #chipFor(value) {
      const choice = this.choices.find((choice2) => choice2.value === value);
      return choice ?? { label: value, value };
    }
    // All choices matching the typed text, case-insensitively, by label —
    // members included (they show a checkmark and toggle off).
    #filteredChoices() {
      const query = this._query.trim().toLowerCase();
      return this.choices.filter(
        (choice) => choice.label.toLowerCase().includes(query)
      );
    }
    get #inputElement() {
      return this.querySelector(".multi-select-input");
    }
    #comboboxAttr(value) {
      return this.#hasMenu() ? value : void 0;
    }
    #menuId() {
      return `${this.id || this.#uid}-listbox`;
    }
    #optionId(index) {
      return `${this.#menuId()}-option-${index}`;
    }
    #activeOptionId() {
      return this._open && this._activeIndex >= 0 ? this.#optionId(this._activeIndex) : void 0;
    }
    #openMenu() {
      if (this._open || !this.#hasMenu() || this.disabled || this.#atMax()) {
        return;
      }
      this._open = true;
      document.addEventListener("pointerdown", this.#onOutsidePointerdown);
      if (supportsPopover) {
        window.addEventListener("resize", this.#onViewportChange);
        document.addEventListener("scroll", this.#onViewportChange, {
          capture: true,
          passive: true
        });
        void this.updateComplete.then(() => {
          if (this._open) {
            this.#showMenuPopover();
          }
        });
      }
    }
    #closeMenu() {
      if (!this._open) {
        return;
      }
      this._open = false;
      this._activeIndex = -1;
      document.removeEventListener("pointerdown", this.#onOutsidePointerdown);
      this.#removeViewportListeners();
      this.#hideMenuPopover();
    }
    #removeViewportListeners() {
      window.removeEventListener("resize", this.#onViewportChange);
      document.removeEventListener("scroll", this.#onViewportChange, {
        capture: true
      });
    }
    #onViewportChange = () => {
      this.#positionMenu();
    };
    #showMenuPopover() {
      const menu = this.#menuElement;
      if (!supportsPopover || !menu || this.#popoverShown) {
        return;
      }
      menu.showPopover();
      this.#popoverShown = true;
      this.#positionMenu();
    }
    #hideMenuPopover() {
      const menu = this.#menuElement;
      if (!supportsPopover || !menu || !this.#popoverShown) {
        return;
      }
      menu.hidePopover();
      this.#popoverShown = false;
    }
    // Anchor the top-layer menu to the field in viewport coordinates: below
    // the field, spanning its width, capped to the space above the
    // viewport's bottom edge so a low menu scrolls internally rather than
    // running off screen. (The absolute fallback positions in CSS instead.)
    #positionMenu() {
      const menu = this.#menuElement;
      const field = this.querySelector(".multi-select-field");
      if (!menu || !field) {
        return;
      }
      const rect = field.getBoundingClientRect();
      const top = rect.bottom + menuSpacer;
      menu.style.left = `${rect.left}px`;
      menu.style.top = `${top}px`;
      menu.style.width = `${rect.width}px`;
      menu.style.maxHeight = `${Math.max(
        0,
        Math.min(menuMaxHeight, window.innerHeight - top - menuViewportGutter)
      )}px`;
    }
    get #menuElement() {
      return this.querySelector(".dropdown-menu");
    }
    #onOutsidePointerdown = (event) => {
      if (!this.contains(event.target)) {
        this.#closeMenu();
      }
    };
    // Pressing on the menu must not steal focus from the text input —
    // otherwise the input blurs before the option's click event lands.
    #onMenuMousedown = (event) => {
      event.preventDefault();
    };
    // Clicking anywhere in the field — its padding or the caret — focuses
    // the text input and opens the menu. Clicks on the input itself or
    // inside a chip keep their native behavior (caret placement, removal).
    // preventDefault stops the press from blurring an already-focused input,
    // which would flicker the menu closed and back open.
    #onFieldMousedown = (event) => {
      const target = event.target;
      if (this.disabled || target.closest(".multi-select-input, bsides-chip") !== null) {
        return;
      }
      event.preventDefault();
      this.#inputElement?.focus();
      this.#openMenu();
    };
    #onFocus = () => {
      this.#openMenu();
    };
    #onBlur = () => {
      this.#closeMenu();
    };
    #onInput = (event) => {
      this._query = event.target.value;
      this.#openMenu();
      this._activeIndex = this.#filteredChoices().length > 0 ? 0 : -1;
      this.#scrollActiveIntoView();
    };
    #onKeydown = (event) => {
      const input = event.target;
      if (event.key === "Backspace" && input.value === "") {
        this.#removeLast();
        return;
      }
      if (!this.#hasMenu()) {
        if (event.key === "Enter") {
          event.preventDefault();
          this.#createFree(input.value);
        }
        return;
      }
      const options = this.#filteredChoices();
      switch (event.key) {
        case "ArrowDown":
          event.preventDefault();
          this.#openMenu();
          this.#moveActive(1, options.length);
          this.#scrollActiveIntoView();
          break;
        case "ArrowUp":
          event.preventDefault();
          this.#openMenu();
          this.#moveActive(-1, options.length);
          this.#scrollActiveIntoView();
          break;
        case "Enter": {
          event.preventDefault();
          const choice = this._activeIndex >= 0 && this._activeIndex < options.length ? options[this._activeIndex] : this.#exactMatch(options, input.value);
          if (choice) {
            this.#toggleChoice(choice);
          } else if (this.edit === "free") {
            this.#createFree(input.value);
          }
          break;
        }
        case "Escape":
          if (this._open) {
            this.#closeMenu();
          } else {
            this.#clearQuery();
          }
          break;
        case "Tab":
          this.#closeMenu();
          break;
      }
    };
    // Keep the active option visible. The combobox pattern focuses the
    // text input, never the option — the active option is only virtually
    // focused, and browsers auto-scroll only the truly focused element.
    // Scoped scrollTop math rather than scrollIntoView so only the menu
    // ever scrolls (never the page or a containing card); the options'
    // offsetParent is the menu on both positioning paths.
    #scrollActiveIntoView() {
      void this.updateComplete.then(() => {
        const menu = this.#menuElement;
        const option = menu?.querySelector(".dropdown-item.active");
        if (!menu || !option) {
          return;
        }
        const styles = getComputedStyle(menu);
        const top = option.offsetTop - (parseFloat(styles.paddingTop) || 0);
        const bottom = option.offsetTop + option.offsetHeight + (parseFloat(styles.paddingBottom) || 0);
        if (top < menu.scrollTop) {
          menu.scrollTop = top;
        } else if (bottom > menu.scrollTop + menu.clientHeight) {
          menu.scrollTop = bottom - menu.clientHeight;
        }
      });
    }
    // Move the active option by delta, wrapping at the ends; entering the
    // list lands on the first (down) or last (up) option.
    #moveActive(delta, count) {
      if (count === 0) {
        this._activeIndex = -1;
        return;
      }
      this._activeIndex = this._activeIndex < 0 ? delta > 0 ? 0 : count - 1 : (this._activeIndex + delta + count) % count;
    }
    #exactMatch(options, text) {
      const query = text.trim().toLowerCase();
      if (!query) {
        return void 0;
      }
      const matches = options.filter(
        (choice) => choice.label.toLowerCase() === query
      );
      return matches.length === 1 ? matches[0] : void 0;
    }
    // Selecting a listed choice toggles its membership: members are
    // removed, non-members added (dropdown click or Enter).
    #toggleChoice(choice) {
      if (this.chips.includes(choice.value)) {
        this.#removeMember(choice.value);
        return;
      }
      this.#addMember(choice);
    }
    #addMember(choice) {
      if (this.#atMax() || this.chips.includes(choice.value)) {
        return;
      }
      this.chips = [...this.chips, choice.value];
      this.#clearQuery();
      this._activeIndex = -1;
      this._announcement = `${choice.label} added`;
      this.#dispatchChange();
      if (this.#atMax()) {
        this.#closeMenu();
      }
    }
    // Create a chip from typed text (edit = "free"). Duplicates are
    // rejected; the typed text stays so the collision is visible.
    #createFree(text) {
      const value = text.trim();
      if (!value || this.#atMax() || this.chips.includes(value)) {
        return;
      }
      this.#addMember({ label: value, value });
    }
    #removeLast() {
      if (this.chips.length === 0) {
        return;
      }
      this.#removeMember(this.chips[this.chips.length - 1]);
    }
    #removeMember(value) {
      this.chips = this.chips.filter((chip) => chip !== value);
      this._announcement = `${this.#chipFor(value).label} removed`;
      this.#dispatchChange();
    }
    #clearQuery() {
      const input = this.#inputElement;
      if (input) {
        input.value = "";
      }
      this._query = "";
    }
    // A chip's close button requested removal.
    #onChipRemove = (event) => {
      const { value } = event.detail;
      this.#removeMember(value);
      void this.updateComplete.then(() => {
        this.#inputElement?.focus();
      });
    };
    #dispatchChange() {
      void this.updateComplete.then(() => {
        this.dispatchEvent(
          new CustomEvent("bsides-multi-select:change", { bubbles: true })
        );
      });
    }
  };
  customElements.define("bsides-multi-select", BsidesMultiSelect);

  // srcts/src/components/inputMultiSelect.ts
  var MultiSelectInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, "bsides-multi-select");
    }
    getValue(el) {
      return el.chips;
    }
    // Matches the input handler registered by the R side (empty selection
    // becomes NULL).
    getType(el) {
      void el;
      return "bsides.multiselect";
    }
    subscribe(el, callback) {
      this.listen(el, "bsides-multi-select:change", () => {
        callback(false);
      });
    }
    // All state changes live in the component; the binding only forwards.
    receiveMessage(el, data) {
      el.receiveUpdate(data);
    }
  };
  registerBinding(MultiSelectInputBinding, "multiselect");

  // srcts/src/components/inputNumeric.ts
  function asAttr(value) {
    return value == null ? "" : `${value}`;
  }
  var NumericInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-numeric");
    }
    // An empty or unparseable field reports `null`, which reaches the server as
    // `NULL`. Shiny's binding returns the raw string when it cannot parse; that
    // would hand R a character where it expects a number.
    getValue(el) {
      if (/^\s*$/.test(el.value)) {
        return null;
      }
      const value = Number(el.value);
      return isNaN(value) ? null : value;
    }
    setValue(el, value) {
      el.value = asAttr(value);
    }
    subscribe(el, callback) {
      this.listen(el, "keyup", () => {
        callback(true);
      });
      this.listen(el, "input", () => {
        callback(true);
      });
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el),
        min: el.min,
        max: el.max,
        step: el.step
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "value")) {
        this.setValue(el, data.value);
      }
      if (hasDefinedProperty(data, "min")) {
        el.min = asAttr(data.min);
      }
      if (hasDefinedProperty(data, "max")) {
        el.max = asAttr(data.max);
      }
      if (hasDefinedProperty(data, "step")) {
        el.step = asAttr(data.step);
      }
      if (hasDefinedProperty(data, "disable")) {
        el.disabled = data.disable;
      }
      announce(el);
    }
    getRatePolicy(el) {
      void el;
      return {
        policy: "debounce",
        delay: 250
      };
    }
  };
  registerBinding(NumericInputBinding, "numeric");

  // srcts/src/components/inputRadioGroup.ts
  var RadioGroupInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-radio-group");
    }
    getValue(el) {
      return el.querySelector(
        ".form-check-input:checked,.btn-check:checked"
      )?.value;
    }
    subscribe(el, callback) {
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "options")) {
        el.innerHTML = data.options;
      }
      const radios = el.querySelectorAll(
        ".form-check-input,.btn-check"
      );
      if (hasDefinedProperty(data, "select")) {
        for (const radio of radios) {
          radio.checked = data.select.includes(radio.value);
        }
      }
      if (hasDefinedProperty(data, "disable")) {
        for (const radio of radios) {
          radio.disabled = data.disable.includes(radio.value);
        }
      }
      announce(el);
    }
  };
  registerBinding(RadioGroupInputBinding, "radiogroup");

  // srcts/src/components/inputRange.ts
  var RangeInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-range");
    }
    getValue(el) {
      return Number(this.#rangeOf(el).value);
    }
    subscribe(el, callback) {
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: this.getValue(el)
      };
    }
    receiveMessage(el, data) {
      const range = this.#rangeOf(el);
      if (hasDefinedProperty(data, "value")) {
        range.value = String(data.value);
      }
      if (hasDefinedProperty(data, "disable")) {
        range.disabled = data.disable;
      }
      announce(el);
    }
    #rangeOf(el) {
      return el.querySelector(".form-range");
    }
  };
  registerBinding(RangeInputBinding, "range");

  // srcts/src/components/inputSelect.ts
  var SelectInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-select");
    }
    getValue(el) {
      return el.value;
    }
    setValue(el, value) {
      el.value = value;
    }
    subscribe(el, callback) {
      this.listen(el, "change", () => {
        callback(false);
      });
    }
    getState(el) {
      return {
        value: el.value
      };
    }
    receiveMessage(el, data) {
      if (hasDefinedProperty(data, "options")) {
        el.innerHTML = data.options;
      }
      if (hasDefinedProperty(data, "select")) {
        this.setValue(el, data.select);
      }
      if (hasDefinedProperty(data, "disable")) {
        for (const option of el.options) {
          option.disabled = data.disable.includes(option.value);
        }
      }
      announce(el);
    }
  };
  registerBinding(SelectInputBinding, "select");

  // srcts/src/components/inputText.ts
  var TextInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-text");
    }
    getValue(el) {
      return el.value;
    }
    setValue(el, value) {
      el.value = value;
    }
    subscribe(el, callback) {
      this.listen(el, "keyup", () => {
        callback(true);
      });
      this.listen(el, "input", () => {
        callback(true);
      });
      this.listen(el, "change", () => {
        callback(false);
      });
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
      announce(el);
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
  var TextGroupInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-input-text-group");
    }
    getValue(el) {
      if (!this.#inputOf(el).value) {
        return null;
      }
      return [...el.querySelectorAll(".input-group-text,input")].map((e5) => e5.textContent || e5.value || "").join("");
    }
    subscribe(el, callback) {
      this.listen(el, "keyup", () => {
        callback(true);
      });
      this.listen(el, "input", () => {
        callback(true);
      });
      this.listen(el, "change", () => {
        callback(false);
      });
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
      const input = this.#inputOf(el);
      if (hasDefinedProperty(data, "value")) {
        input.value = data.value;
      }
      if (hasDefinedProperty(data, "disable")) {
        input.disabled = data.disable;
      }
      announce(el);
    }
    #inputOf(el) {
      return el.querySelector("input");
    }
  };
  registerBinding(TextGroupInputBinding, "textgroup");

  // srcts/src/components/modal.ts
  var import_bootstrap = __toESM(require_bootstrap());
  var Modal = class _Modal extends import_bootstrap.Modal {
    isShown() {
      return this._isShown;
    }
    static addMessageHandlers() {
      addCustomMessageHandler("modalShow", (data) => {
        if (typeof data.modal === "object") {
          void _Modal.showOrInsertModal(data.modal);
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
  var ModalInputBinding = class extends NativeEventInputBinding {
    find(scope) {
      return findAll(scope, ".bsides-modal");
    }
    getValue(el) {
      const modal = Modal.getInstance(el);
      if (!modal) {
        return null;
      }
      return modal.isShown() ? "shown" : "hidden";
    }
    subscribe(el, callback) {
      this.listen(el, "shown.bs.modal", () => {
        callback(false);
      });
      this.listen(el, "hidden.bs.modal", () => {
        callback(false);
      });
    }
  };
  Modal.addMessageHandlers();
  registerBinding(ModalInputBinding, "modal");
})();
/*! Bundled license information:

@lit/reactive-element/css-tag.js:
  (**
   * @license
   * Copyright 2019 Google LLC
   * SPDX-License-Identifier: BSD-3-Clause
   *)

@lit/reactive-element/reactive-element.js:
lit-html/lit-html.js:
lit-element/lit-element.js:
lit-html/directive.js:
lit-html/directives/repeat.js:
  (**
   * @license
   * Copyright 2017 Google LLC
   * SPDX-License-Identifier: BSD-3-Clause
   *)

lit-html/is-server.js:
  (**
   * @license
   * Copyright 2022 Google LLC
   * SPDX-License-Identifier: BSD-3-Clause
   *)

lit-html/directive-helpers.js:
  (**
   * @license
   * Copyright 2020 Google LLC
   * SPDX-License-Identifier: BSD-3-Clause
   *)

lit-html/directives/if-defined.js:
  (**
   * @license
   * Copyright 2018 Google LLC
   * SPDX-License-Identifier: BSD-3-Clause
   *)
*/
//# sourceMappingURL=bsides.js.map
