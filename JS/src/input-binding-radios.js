var radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radio-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .find("input[type=\"radio\"]:checked:not(:disabled)")
      .data("value");
    return $val === undefined ? null : $val;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.radioInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".radioInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.context) {
      $el.attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      if (data.context !== "none") {
        $el.addClass("has-" + data.context);
      }
    }

    if (data.disable !== null) {
      $el.find("input[type=\"radio\"]").each(function(i, e) {
        $(e).prop("disabled", data.disable);
      });
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");
