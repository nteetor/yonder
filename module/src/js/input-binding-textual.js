export let textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  Selector: {
    SELF: ".yonder-textual",
    VALIDATE: "input"
  },
  Events: [
    { type: "change", debounce: true },
    { type: "input", debounce: true }
  ],
  getValue: (el) => {
    let input = el.children[0];
    return input.type === "number" ? parseInt(input.value, 10) : input.value;
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  _update: (el, data) => {
    el.children[0].value = data.values[0];
  },
  _disable: (el, data) => {
    el.children[0].setAttribute("disabled", "");
  },
  _enable: (el, data) => {
    el.children[0].removeAttribute("disabled");
  }
});

Shiny.inputBindings.register(textualInputBinding, "yonder.textualInput");
