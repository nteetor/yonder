export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button[id]",
    VALUE: ".btn"
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
  },
  _update: function(el, data) {
    if (data.values === undefined) {
      return false;
    }

    if (data.choices.length) {
      el.innerHTML = data.choices[0];
    }

    if (data.values.length) {
      this._VALUES[el.id] = +(data.values[1]);
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
