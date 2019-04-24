export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-button[id]"),
  initialize: (el) => {
    $(el).on("click", e => el.value = +el.value + 1);
    el.value = 0;
  },
  getValue: (el) => +el.value > 0 ? +el.value : null,
  subscribe: (el, callback) => {
    $(el).on("click.yonder", e => callback());
  },
  unsubscribe: (el, callback) => $(el).off(".yonder"),
  receiveMessage: (el, msg) => {
    if (msg.content) {
      el.innerHTML = msg.content;
    }

    if (msg.enable) {
      el.classList.remove("disabled");
      el.removeAttribute("disabled");
    }

    if (msg.disable) {
      el.classList.add("disabled");
      el.setAttribute("disabled", "");
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
