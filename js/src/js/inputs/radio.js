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
  CHILD: "custom-control-input"
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

  select(values) {
    let children = this._element.querySelectorAll(Selector.CHILD);

    let targets = filterElements(children, values);

    deactivateElements(targets);

    if (targets.length) {
      activateElements(targets[0]);
      this.value(targets[0].value);
    }
  }

  // static ----

  static initialize(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      input = new RadioInput(element);
    }
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
