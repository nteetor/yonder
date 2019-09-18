import $ from "jQuery";
import Shiny from "Shiny";

import Input from "./input.js";
import Store from "../data/store.js";
import MenuInput from "./menu.js";
import {
  findClosest,
  asArray,
  getPluginAttributes,
  activateElement,
  deactivateElement,
  all
} from "../utils/index.js";

const NAME = "nav";
const TYPE = `yonder.${ NAME }`;

const ClassName = {
  INPUT: "yonder-nav",
  CHILD: "nav-link"
};

const Selector = {
  INPUT: `.${ ClassName.INPUT }`,
  CHILD: `.${ ClassName.CHILD }`,
  PARENT_CHILD: `.${ ClassName.INPUT } .${ ClassName.CHILD }`,
  MENU: MenuInput.Selector.INPUT,
  PARENT_MENU: `.${ ClassName.INPUT } ${ MenuInput.Selector.INPUT }`,
  ACTIVE: ".active",
  DISABLED: ".disabled",
  PLUGIN: "[data-plugin]"
};

const Event = {
  CLICK: `click.${ TYPE }`,
  MENU_CLOSE: MenuInput.Event.CLOSE
};

class NavInput extends Input {

  constructor(element) {
    super(element, TYPE);

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

  select(value) {
    if (typeof value === "string") {
      let found = false;
      asArray(this._element.querySelectorAll(Selector.CHILD)).forEach((child) => {
        if (child.value === value) {
          activateElement(child);
          found = true;
        } else {
          deactivateElement(child);
        }
      });

      if (found === true) {
        this.value(value);
      }
    }

    if (value.nodeType === 1) {
      let child = value;
      asArray(this._element.querySelectorAll(Selector.CHILD)).forEach(deactivateElement);
      activateElement(child);
      this.value(child.value);
    }

  }

  disable(values) {

  }

  enable(values) {

  }

  // static ----

  static initialize(element) {
    let input = Store.getData(element, TYPE);

    if (!input) {
      input = new NavInput(element);
    }
  }

  static find(scope) {
    return super.find(scope, Selector.INPUT);
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
    return { ...Input, ...NavInput };
  }
}

// events ----

$(document).on(Event.CLICK, Selector.PARENT_CHILD, (event) => {
  let nav = findClosest(event.target, Selector.INPUT);
  let input = Store.getData(nav, TYPE);

  if (!input) {
    return;
  }

  let button = findClosest(event.target, Selector.CHILD);

  input.select(button);
});

$(document).on(Event.CLICK, `${ Selector.PARENT_CHILD }${ Selector.PLUGIN }`, (event) => {
  let link = findClosest(event.target, Selector.CHILD);
  let [plugin, action, target] = getPluginAttributes(link);

  if (!all(plugin, action, target)) {
    return;
  }

  deactivateElement(link);

  $(link)[plugin](action);
});

$(document).on(Event.MENU_CLOSE, Selector.PARENT_MENU, (event) => {
  let nav = findClosest(event.target, Event.PARENT);
  let navInput = Store.getData(nav, TYPE);

  if (!navInput) {
    return;
  }

  let dropdown = findClosest(event.target, Selector.DROPDOWN);
  let dropdownInput = Store.getData(dropdown, MenuInput.TYPE);

  if (!dropdownInput) {
    return;
  }

  navInput.value(dropdownInput.value());
});

if (Shiny) {
  Shiny.inputBindings.register(NavInput.ShinyInterface(), TYPE);
}

export default NavInput;

Shiny.addCustomMessageHandler("yonder:pane", (msg) => {
  let _show = function(pane) {
    if (pane === null || pane.classList.contains("show")) {
      return;
    }

    if (!pane.parentElement.classList.contains("tab-content")) {
      console.warn(`nav pane ${ pane.id } is missing a nav content parent element`);
      return;
    }

    let previous = pane.parentElement.querySelector(".active");

    const complete = () => {
      const hiddenEvent = $.Event("hidden.bs.tab", {
        relatedTarget: pane
      });

      const shownEvent = $.Event("shown.bs.tab", {
        relatedTarget: previous
      });

      $(previous).trigger(hiddenEvent);
      $(pane).trigger(shownEvent);
    };

    bootstrap.Tab.prototype._activate(pane, pane.parentElement, complete);
  };

  let _hide = function(pane) {
    if (pane === null || !pane.classList.contains("show")) {
      return;
    }

    if (!pane.parentElement.classList.contains("tab-content")) {
      console.warn(`nav pane ${ pane.id } is missing a nav content parent element`);
      return;
    }

    const complete = () => {
      const hiddenEvent = $.Event("hidden.bs.tab", {
        relatedTarget: pane
      });

      $(pane).trigger(hiddenEvent);
    };

    let dummy = document.createElement("div");

    bootstrap.Tab.prototype._activate(dummy, pane.parentElement, complete);
  };

  if (msg.type === undefined ||
      msg.data === undefined ||
      msg.data.target === undefined) {
    return;
  }

  let target = document.getElementById(msg.data.target);

  if (target === null) {
    return;
  }

  if (msg.type === "show") {
    _show(target);
  } else if (msg.type === "hide") {
    _hide(target);
  }
});
