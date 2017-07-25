var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-select-input");
  },
  getValue: function(el) {
    return $(el).val();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.selectInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".selectInputBinding");
  }
});

Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");
