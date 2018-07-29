export let checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".yonder-checkbar[id]",
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
