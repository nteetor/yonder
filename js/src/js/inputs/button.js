import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import {
  findClosest,
  getPluginAttributes
} from "../utils/index.js";

const NAME = "button";
const TYPE = `yonder.${ NAME }`;

const ClassName = {
  INPUT: "yonder-button"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  PLUGIN: "[data-plugin]"
};

const Event = {
  CLICK: `click.${ TYPE }`
};

class ButtonInput extends Input {

  // fields ----

  static get TYPE() {
    return TYPE;
  }

  // methods ----

  constructor(element) {
    super(element, TYPE);

    this._value = 0;
    this._isLink = element.tagName === "A";
  }


  value(x) {
    if (typeof x === "undefined") {
      return this._value;
    }

    this._value = x;
    this._callback();

    return this;
  }

  content(html) {
    this._element.innerHTML = html;
  }

  disable(values) {
    if (this._isLink) {
      this._element.classList.add("disabled");
    } else {
      this._element.setAttribute("disabled", "");
    }
  }

  enable() {
    if (this._isLink) {
      this._element.classList.remove("disabled");
    } else {
      this._element.removeAttribute("disabled");
    }
  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, ButtonInput);
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT);
  }

  static getValue(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      return null;
    }

    return input.value() === 0 ? null : input.value();
  }

  static subscribe(element, callback) {
    super.subscribe(element, callback, TYPE);
  }

  static unsubscribe(element) {
    super.unsubscribe(element, TYPE);
  }

  static receiveMessage(element, message) {
    super.receiveMessage(element, message, TYPE);
  }

  static ShinyInterface() {
    return { ...Input, ...ButtonInput };
  }
}

// events ----

$(document).on(Event.CLICK, Selector.INPUT, (event) => {
  let button = findClosest(event.target, Selector.INPUT);
  let input = Store.getData(button, TYPE);

  if (!input) {
    return;
  }

  input.value(input.value() + 1);
});

$(document).on(Event.CLICK, `${ Selector.INPUT }${ Selector.PLUGIN }`, (event) => {
  let button = findClosest(event.target, Selector.INPUT);
  let [plugin, action, target] = getPluginAttributes(button);

  if (!(plugin && action && target)) {
    return;
  }

  if (plugin === "tab") {
    $(button).one("shown.bs.tab", (e) => button.classList.remove("active"));
  }

  $(button)[plugin](action);
});

if (Shiny) {
  Shiny.inputBindings.register(ButtonInput.ShinyInterface(), TYPE);
}

export default ButtonInput;
