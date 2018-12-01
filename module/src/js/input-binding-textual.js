export let textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  Selector: {
    SELF: ".yonder-textual[id]",
    VALIDATE: "input"
  },
  Events: [
    { type: "change", debounce: true },
    { type: "input", debounce: true }
  ],
  getValue: function(el) {
    let input = el.querySelector("input");
    let value = input.value;

    if (input.type === "number") {
      return parseInt(value, 10);
    }

    return value;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  _update: function(el, data) {
    data.values && (el.querySelector("input").value = data.values[0]);
  },
  _disable: function(el, data) {
    el.querySelector("input").setAttribute("disabled", "");
  },
  _enable: function(el, data) {
    el.querySelector("input").removeAttribute("disabled");
  }
});

Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");
