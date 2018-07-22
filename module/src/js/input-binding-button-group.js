export let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    SELF: ".dull-button-group-input",
    VALUE: ".btn",
    LABEL: ".btn"
  },
  _value: null,
  getValue: function(el) {
    return this._value;
  },
  subscribe: function(el, callback) {
    var self = this;
    $(el).on("click.buttonGroupInputBinding", "button", function(e) {
      self._value = $(this).data("value");
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".buttonGroupInputBinding", "button");
  }
});

// Shiny.inputBindings.register(buttonGroupInputBinding, "dull.buttonGroup");
