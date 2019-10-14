import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import {
  findClosest,
  filterElements,
  deactivateElements,
  activateElements,
  getPluginAttributes,
  all
} from "../utils/index.js";

const NAME = "radio";
const TYPE = `yonder.${ NAME }`;

const ClassName = {
  INPUT: "yonder-radio",
  CHILD: "custom-radio"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  INPUT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  PLUGIN: "[data-plugin]"
};

const Event = {
  CHANGE: `change.${ TYPE }`
};

class RadioInput extends Input {

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

    let [targets, values] = filterElements(children, x);

    deactivateElements(children, child => {
      child.children[0].checked = false;
    });

    if (targets.length) {
      activateElements(targets[0], target => {
        target.children[0].checked = true;
      });
      this.value(values[0]);
    }
  }

  // static ----

  static initialize(element) {
    super.initialize(element, TYPE, RadioInput);
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT);
  }

  static getValue(element) {
    return super.getValue(element, TYPE);
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
    return { ...Input, ...RadioInput };
  }
}

// events ----

$(document).on(Event.CHANGE, Selector.INPUT_CHILD, (event) => {
  let radio = findClosest(event.target, Selector.INPUT);
  let radioInput = Store.getData(radio, TYPE);

  if (!radioInput) {
    return;
  }

  let input = findClosest(event.target, Selector.CHILD);

  radioInput.value(input.value);
});

$(document).on(Event.CHANGE, `${ Selector.INPUT_CHILD }${ Selector.PLUGIN }`, (event) => {
  let input = findClosest(event.target, Selector.CHILD);
  let [plugin, action, target] = getPluginAttributes(input);

  if (!all(plugin, action, target)) {
    return;
  }

  $(input)[plugin](action);
});

// shiny ----

// If shiny is present register the radio input shiny interface with the input
// bindings.
if (Shiny) {
  Shiny.inputBindings.register(RadioInput.ShinyInterface(), TYPE);
}

export default RadioInput;
