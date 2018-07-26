export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".dull-button-input",
    VALUE: ".dull-button-input",
    LABEL: ".dull-button-input"
  },
  Events: [
    {
      type: "click",
      callback: el => el.setAttribute("data-value", el.getAttribute("data-value") + 1)
    }
  ],
  initialize: function(el) {
    el.setAttribute("data-value", 0);
  },
  getType: function(el) {
    return "dull.button";
  },
  getValue: function(el) {
    return el.getAttribute("data-value");
  }
});

// Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");
