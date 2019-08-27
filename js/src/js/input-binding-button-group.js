export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-button-group[id]"),
  getType: (el) => "yonder.button.group",
  initialize: (el) => {
    $(el).on("click", "button", (e) => {
      buttonGroupInputBinding._VALUES[el.id] = e.delegateTarget.value;
    });

    buttonGroupInputBinding._VALUES[el.id] = null;
  },
  getValue: (el) => {
    return { force: Date.now(), value: buttonGroupInputBinding._VALUES[el.id] };
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
      buttonGroupInputBinding._VALUES[el.id] = msg.value;
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
