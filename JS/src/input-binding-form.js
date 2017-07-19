var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form[id]");
  },
  getValue: function(el) {
    var $inputs = $(el).find(".dull-input[id]");

    if (!$inputs.length) {
      return null;
    }

    return $inputs
      .map(function(i, e) {
        var ids = $(e)
          .parentsUntil(".dull-form", "[id]")
          .map(function(j, a) { return a.id; })
          .get();

        ids.push(e.id);
        ids.reverse();

        return ids.reduce(function(acc, obj) {
          var ret = {};
          ret[obj] = acc;
          return ret;
        }, $(e).val() || null);
      })
      .get()
      .reduce(function(acc, obj) {
        var key = Object.keys(obj);

        if (!acc.hasOwnProperty(key)) {
          return Object.assign(acc, obj);
        } else {
          var nested = {};
          nested[key] = Object.assign(acc[key], obj[key]);
          return Object.assign(acc, nested);
        }
      }, {});
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("dull:formchange.formInputBinding", function(e) {
      callback();
    });
    $(el).on("dull:formsubmit.formInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");

$(document).ready(function() {
  $(".dull-form[id]").on("submit", function(e) {
    e.preventDefault();
    $(this).trigger("dull:formsubmit");
  });
});
