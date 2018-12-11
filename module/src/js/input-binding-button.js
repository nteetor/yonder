export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button"
  },
  Events: [
    { "type": "click", callback: el => el.value = +el.value + 1 }
  ],
  Type: "yonder.button",
  initialize: function(el) {
    el.value = 0;
  },
  getValue: function(el) {
    return { force: Date.now(), value: el.value };
  },
  _update: function(el, data) {
    if (data.choices) {
      el.innerHTML = data.choices[0];

      if (data.values[0] === 0) {
        el.value = 0;
      } else {
        el.value = +data.values[0] || el.value;
      }
    }
  },
  _enable: function(el, data) {
    el.classList.remove("disabled");
  },
  _disable: function(el, data) {
    el.classList.add("disabled");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
