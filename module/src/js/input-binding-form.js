var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function(el) {
    return null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("submit.formInputBinding", (e) => {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");
