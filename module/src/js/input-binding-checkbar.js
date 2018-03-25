var checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".dull-checkbar-input",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn.active input"
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

Shiny.inputBindings.register(checkbarInputBinding, "dull.checkbarInput");
