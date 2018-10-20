export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn input:checked"
  },
  Events: [
    { type: "click" },
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "yonder.radiobarInput");
