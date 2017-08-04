$(document).ready(function() {
  $(".dull-form-input[id]").on("click", ".dull-submit", function(e) {
    console.log("wat");
    e.preventDefault();
    $(this).trigger("dull:submit");
  });
});

var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function(el) {
    return $(el).find(".dull-input[id]")
      .map(function() {
        return this.id;
      })
      .get()
      .reduce(function(acc, obj) {
        acc[obj] = Shiny.shinyapp.$inputValues[obj];
        return acc;
      }, {});
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("dull:submit.formInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");

