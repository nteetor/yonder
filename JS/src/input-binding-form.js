$(document).ready(function() {
  $(".dull-form-input[id]").on("shiny:inputchanged", ".dull-input[id]", function(e, data) {
    if (!data.submit) {
      e.preventDefeault();
    }
  });
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
      $(el).find(".dull-input[id]").trigger("shiny:inputchanged", {
        submit: true
      });
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");
