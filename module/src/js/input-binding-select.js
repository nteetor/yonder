export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".dull-select-input",
    VALUE: "option",
    LABEL: "option",
    SELECTED: "option:checked",
    VALIDATE: "select"
  },
  Events: [
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

// Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");
