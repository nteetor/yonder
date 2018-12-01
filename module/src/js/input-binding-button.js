export let buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".yonder-button"
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
    if (data.choices) {
      el.innerHTML = data.choices[0];
    }

    if (data.values) {
      this._VALUES[el.id] = +(data.values[0]);
    }
  },
  _enable: function(el, data) {
    el.classList.remove("disabled");
  },
  _disable: function(el, data) {
    el.classList.add("disabled");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "yonder.buttonInput");
