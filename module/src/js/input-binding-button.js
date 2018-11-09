export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button[id]",
    VALUE: ".yonder-button",
    LABEL: ".yonder-button"
  },
  Events: [
    {
      "type": "click",
      "callback": (el, _, self) => self._VALUES[el.id] += 1
    }
  ],
  _VALUES: {},
  initialize: function(el) {
    this._VALUES[el.id] = 0;
  },
  getType: function(el) {
    return "yonder.button";
  },
  getValue: function(el) {
    return this._VALUES[el.id];
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
