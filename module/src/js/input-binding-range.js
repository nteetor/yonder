export let rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-range[id]"),
  getId: (el) => el.id,
  getValue: (el) => +el.children[0].value,
  subscribe: (el, callback) => {
    let $el = $(el);

    $el.on("input.yonder", callback(true));
    $el.on("range.value.yonder");
  },
  unsubscribe: (el) => $(el).off("yonder"),
  receiveMessage: (el, msg) => {
    let input = el.children[0];

    if (msg.value) {
      input.value = msg.value;
    }

    if (msg.enable) {
      input.removeAttribute("disabled");
    }

    if (msg.disable) {
      input.setAttribute("disabled", "");
    }
  }
});

Shiny.inputBindings.register(rangeInputBinding, "yonder.rangeInput");
