import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import {
  findClosest
} from "../utils/index.js";

const NAME = "menu";
const TYPE = `yonder.${ NAME }`;

const ClassName = {
  INPUT: "yonder-menu",
  CHILD: "dropdown-item"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT }  .${ ClassName.CHILD }`
};

const Event = {
  CLICK: `click.${ TYPE }`,
  CLOSE: "hide.bs.dropdown",
  CLOSED: "hidden.bs.dropdown"
};

class MenuInput extends Input {

  constructor(element) {
    super(element, TYPE);

    this._counter = 0;

    Store.setData(element, TYPE, this);
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value;
    }

    this._value = x;
    this._callback();

    return this;
  }

  // static ----

  static get TYPE() {
    return TYPE;
  }

  static get Selector() {
    return Selector;
  }

  static get Event() {
    return Event;
  }

  static initialize(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      input = new MenuInput(element);
    }
  }

  static find(element) {
    return super.find(element, Selector.INPUT);
  }

  static getType(element) {
    return TYPE;
  }

  static getValue(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      return null;
    }

    return { value: input.value(), counter: input._counter++ };
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
    return { ...Input, ...MenuInput };
  }
}

$(document).on(Event.CLICK, Selector.PARENT_CHILD, (event) => {
  let item = findClosest(event.target, Selector.CHILD);

  if (!item) {
    return;
  }

  let menu = findClosest(item, Selector.INPUT);
  let menuInput = Store.getData(menu, TYPE);

  if (!menuInput) {
    return;
  }

  menuInput.value(item.value);
});

if (Shiny) {
  Shiny.inputBindings.register(MenuInput.ShinyInterface(), TYPE);
}

export default MenuInput;
