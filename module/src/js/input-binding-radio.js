export let radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".yonder-radio[id]",
    CHILD: ".custom-radio",
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

Shiny.inputBindings.register(radioInputBinding, "yonder.radioInput");
