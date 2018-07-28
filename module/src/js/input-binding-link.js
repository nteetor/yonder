export let linkInputBinding = new Shiny.InputBinding();

$.extend(linkInputBinding, {
  Selector: {
    SELF: ".dull-link-input"
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
    return "dull.link";
  },
  getValue: function(el) {
    return {
      value: el.getAttribute("data-value"),
      id: el.id
    };
  }
});

// Shiny.inputBindings.register(linkInputBindng, "dull.linkInput");
