var checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-checkbar-input[id]");
  },
  getValue: function(el) {
    return $(el).find("input[type=checkbox]:checked")
      .map((i, e) => $(e).data("value"))
      .get();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.checkbarInputBinding", function(e) {
      callback();
    });
    $(el).on("change.checkbarInputBinding", function(e) {
      callback();
    });
  },
  unsubcribe: function(el) {
    $(el).off(".checkbarInputBinding");
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "checkbarInput");
