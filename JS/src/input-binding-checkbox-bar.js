var checkboxBarInputBinding = new Shiny.InputBinding();

$.extend(checkboxBarInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-checkbox-bar[id]");
  },
  getValue: function(el) {
    return $(el)
      .find("input[type=\"checkbox\"]:checked")
      .map(function(i, e) {
        return $(e).data("value");
      })
      .get();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.checkboxBarInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxBarInputBinding");
  }
});

Shiny.inputBindings.register(checkboxBarInputBinding, "checkboxBarInput");
