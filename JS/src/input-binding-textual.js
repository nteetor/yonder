var textInputBinding = new Shiny.InputBinding();

$.extend(textInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-text[id]");
  },
  getValue: function(el) {
    return $(el).val() || null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textInputBinding");
  }
});

Shiny.inputBindings.register(textInputBinding, "dull.textInput");
