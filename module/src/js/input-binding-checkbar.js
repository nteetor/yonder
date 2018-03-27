var checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".dull-checkbar-input",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn.active input"
  },
  Events: [
    { type: "change" },
    { type: "click" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "dull.checkbarInput");
