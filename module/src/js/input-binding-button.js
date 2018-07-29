export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button[id]",
    VALUE: ".yonder-button",
    LABEL: ".yonder-button"
  },
  Events: [
    {
      type: "click",
      callback: el => el.setAttribute("data-value", +el.getAttribute("data-value") + 1)
    }
  ],
  initialize: function(el) {
    el.setAttribute("data-value", 0);
  },
  getType: function(el) {
    return "yonder.button";
  },
  getValue: function(el) {
    return el.getAttribute("data-value");
  }
});
