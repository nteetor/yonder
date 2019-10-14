import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import {
  findClosest,
  asArray,
  isNode,
  activateElements,
  deactivateElements,
  filterElements
} from "../utils/index.js";

const NAME = "checkbar";
const TYPE = `yonder.${ TYPE }`;

const ClassName = {
  INPUT: "yonder-checkbar",
  CHILD: "btn"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`
};

const Event = {
  CHANGE: `change.${ TYPE }`
};

class CheckbarInput extends Input {

  // methods ----

  constructor(element) {
    super(element, TYPE);
  }

  value(x) {
    if (typeof x === "undefined") {
      return this._value;
    }

    this._value = x;
    this._callback();

    return this;
  }

  select(x) {
    let children = this._element.querySelectorAll(Selector.CHILD);

    let [targets, values]  = filterElements(children, x, child => child.querySelector("input").value);

    console.log(values);

    deactivateElements(children, child => {
      child.children[0].checked = false;
    });

    if (targets.length) {
      activateElements(targets, target => {
        target.children[0].checked = true;
      });
      this.value(values);
    }
  }

  // static

  static find(scope) {
    return super.find(scope, Selector.INPUT);
  }

  static initialize(element) {
    super.initialize(element, TYPE, CheckbarInput);
  }

  static getValue(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      return null;
    }

    return input.value();
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
    return { ...Input, ...CheckbarInput };
  }
}

// events ----

$(document).on(Event.CHANGE, Selector.PARENT_CHILD, (event) => {
  let checkbar = findClosest(event.target, Selector.INPUT);
  let checkbarInput = Store.getData(checkbar, TYPE);

  if (!checkbarInput) {
    return;
  }

  let button = findClosest(event.target, Selector.CHILD);

  checkbarInput.select(button);
});

export default CheckbarInput;

if (Shiny) {
  Shiny.inputBindings.register(CheckbarInput.ShinyInterface(), TYPE);
}
