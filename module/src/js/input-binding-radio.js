export let radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".dull-radio-input",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

// Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");
