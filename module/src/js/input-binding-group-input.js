export let groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".yonder-group[id]",
    VALUE: "input",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
  },
  Events: [
    { type: "input", debounce: true },
    { type: "change", debounce: true }
  ],
  getType: function(el) {
    return "yonder.group";
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  _update: function(el, data) {
    if (data.values) {
      let input = el.querySelector("input");
      input.value = data.values[0];
    }
  },
  _enable: function(el, data) {
    let input = el.querySelector("input");

    if (input !== null) {
      input.removeAttribute("disabled");
    }
  },
  _disable: function(el, data) {
    let input = el.querySelector("input");

    if (input !== null) {
      input.setAttribute("disabled", "");
    }
  },
  _validate: function(el, data) {
    let input = el.querySelector("input");

    if (input !== null) {
      input.classList.remove("is-invalid");
    }
  },
  _invalidate: function(el, data) {
    let input = el.querySelector("input");

    if (input !== null) {
      input.classList.add("is-invalid");
    }
  }
});

Shiny.inputBindings.register(groupInputBinding, "yonder.groupInput");
