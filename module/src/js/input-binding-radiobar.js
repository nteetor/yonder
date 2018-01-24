var radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radiobar-input[id]");
  },
  getValue: function(el) {
    return $(el).find("input[type=radio]:checked").data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.radiobarInputBinding", function(e) {
      callback();
    });
    $(el).on("change.radiobarInputBinding", function(e) {
      callback();
    });
  },
  unsubcribe: function(el) {
    $(el).off(".radiobarInputBinding");
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "radiobarInput");
