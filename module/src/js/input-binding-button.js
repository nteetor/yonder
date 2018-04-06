var buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".dull-button-input",
    VALUE: ".dull-button-input",
    LABEL: ".dull-button-input"
  },
  Events: [
    { type: "click", callback: (el) => $(el).data().value++ }
  ],
  initialize: function(el) {
    $(el).data("value", 0);
  },
  getType: function(el) {
    return "dull.button";
  },
  getValue: function(el) {
    return $(el).data("value");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");
