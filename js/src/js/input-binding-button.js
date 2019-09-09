import { actionListener } from "./actions.js";

export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-button[id]"),
  initialize: (el) => {
    el.value = 0;

    $(el).on("click", e => el.value = +el.value + 1);

    actionListener(el, null, "click");
  },
  getValue: (el) => +el.value > 0 ? +el.value : null,
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("click.yonder", (e) => callback());
    $el.on("button.value.yonder", (e) => callback());
  },
  unsubscribe: (el, callback) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.innerHTML = msg.content;
    }

    if (msg.value !== null && msg.value !== undefined) {
      el.value = msg.value;
      $(el).trigger("button.value.yonder");
    }

    if (msg.enable) {
      el.classList.remove("disabled");
      el.removeAttribute("disabled");
    }

    if (msg.disable) {
      el.classList.add("disabled");
      el.setAttribute("disabled", "");
    }

    if (msg.tooltip !== null) {
      el.setAttribute("data-animation", msg.tooltip.fade);
      el.setAttribute("data-html", "true");
      el.setAttribute("data-placement", msg.tooltip.placement);
      el.setAttribute("data-toggle", "tooltip");
      el.setAttribute("title", msg.tooltip.title);
      el.setAttribute("data-original-title", msg.tooltip.title);

      $(el).tooltip();

      if (el.matches(":hover")) {
        $(el).tooltip("show");
      }
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
