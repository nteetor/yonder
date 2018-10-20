export let selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".yonder-select[id]",
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

Shiny.inputBindings.register(selectInputBinding, "yonder.selectInput");
