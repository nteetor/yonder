var radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".dull-radio-input",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)"
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.radioInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".radioInputBinding");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");
