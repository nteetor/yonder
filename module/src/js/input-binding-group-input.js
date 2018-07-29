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
  }
});
