var buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-button-group-input[id]");
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

Shiny.inputBindings.register(buttonGroupInputBinding, "dull.buttonGroup");
