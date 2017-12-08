var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-select-input[id]");
  },
  getValue: function(el) {
    return $(el)
      .find("option:checked")
      .map(function(i, e) {
        var $val = $(e).data("value");
        return $val === undefined ? null : $val;
      })
      .get();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var self = this;
    $(el).on("change.selectInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".selectInputBinding");
  },
  receiveMessage: function(el, data) {
    if (data.validate !== undefined) {
      $("select", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("select", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }
  }
});

Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");
