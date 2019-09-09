import { actionListener } from "./actions.js";

export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  _VALUES: {},
  find: (scope) => scope.querySelectorAll(".yonder-button-group[id]"),
  getType: (el) => "yonder.button.group",
  initialize: (el) => {
    buttonGroupInputBinding._VALUES[el.id] = null;

    $(el).on("click", "button", (e) => {
      el.setAttribute("data-value", e.currentTarget.value);
    });

    actionListener(el, "button", "click");
  },
  getValue: (el) => {
    let value = el.getAttribute("data-value");

    if (value === undefined) {
      value = null;
    }

    return { force: Date.now(), value: value };
  },
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", "button", (e) => callback());
    $el.on("buttongroup.value.yonder", (e) => callback());
  },
  unsubscribe: (el) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.innerHTML = msg.content;
    }

    if (msg.value) {
      el.setAttribute("data-value", msg.value);
    }

    if (msg.enable) {
      el.querySelectorAll("button").forEach(btn => {
        if (msg.enable === true || msg.enable.indexOf(btn.value) > -1) {
          btn.classList.remove("disabled");
          btn.removeAttribute("disabled");
        }
      });
    }

    if (msg.disable) {
      el.querySelectorAll("button").forEach(btn => {
        if (msg.disable === true || msg.disable.indexOf(btn.value) > -1) {
          btn.classList.add("disabled");
          btn.setAttribute("disabled", "");
        }
      });
    }
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "yonder.buttonGroupInput");
