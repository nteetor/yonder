export let groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".dull-group-input",
    VALUE: "input",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
  },
  Events: [
    { type: "input", debounce: true },
    { type: "change", debounce: true }
  ],
  getType: function(el) {
    return "dull.group.input";
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  }
});

// Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");
