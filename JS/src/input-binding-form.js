var formInputBinding = new Shiny.InputBinding();

$(document).ready(function() {
  $(".dull-form-input[id]").each(function(i, el) {
    $(el).find(".dull-input[id]").each(function(j, e) {
      $(e).data("id", e.id)
        .attr("id", el.id + "__" + e.id)
        .data("parent-form", el.id);
    });
  });
});

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function(el) {
    var value = $(el).find(".dull-input[id]")
      .map(function() {
        let obj = {};

        let v = Shiny.shinyapp.$inputValues[this.id + ":dull.form.element"];
        if (v === undefined) {
          return obj;
        }

        obj[$(this).data("id")] = v;

        return obj;
      })
      .get()
      .reduce((acc, obj) => Object.assign(acc, obj));

    if (Object.keys(value).length === 0) {
      return null;
    }

    return value;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("submit.formInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");
