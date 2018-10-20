export let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".yonder-checkbox[id]",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  getValue: function(el) {
    var $val = $(el)
      .find(`${ this.Selector.SELECTED }`)
      .data("value");
    return $val === undefined ? null : $val;
  },
  _getLabel: function(el) {
    return $(el).find(`${ this.Selector.LABEL }`).text();
  },
  getState: function(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "yonder.checkboxInput");
