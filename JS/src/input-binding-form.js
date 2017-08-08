var formInputBinding = new Shiny.InputBinding();

$(document).ready(function() {
  $(".dull-form-input[id]").each(function(i, el) {
    $(el).find(".dull-input[id]").each(function(j, e) {
      var newid = $(el).attr("id") + "__" + $(e).attr("id");
      console.log(newid);
      $(e).attr("id", newid);
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
        return this.id;
      })
      .get()
      .reduce(function(acc, obj) {
        var key = obj + ":dull.form.element";
        var name = obj.substring(obj.indexOf("__") + 2);

        if (Shiny.shinyapp.$inputValues[key] !== undefined) {
          acc[name] = Shiny.shinyapp.$inputValues[key];
        }

        return acc;
      }, {});

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
