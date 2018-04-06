let linkInputBindng = new Shiny.InputBinding();

$.extend(linkInputBindng, {
  Selector: {
    SELF: ".dull-link-input"
  },
  Events: [
    { type: "click", callback: (el) => $(el).data().value++ }
  ],
  initialize: function(el) {
    $(el).data("value", 0);
  },
  getType: function(el) {
    return "dull.link";
  },
  getValue: function(el) {
    return $(el).data("value");
  }
});

Shiny.inputBindings.register(linkInputBindng, "dull.linkInput");
