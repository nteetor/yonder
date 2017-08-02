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

    if (data.value !== undefined) {
      $el.find("input[type=\"radio\"]").each(function(i, e) {
        $(e).data("value", data.value);
      });
    }

    if (data.state !== undefined) {
      $el.attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      $el.find(".form-control-feedback").empty();

      if (data.state !== null) {
        $el.addClass("has-" + data.state);
      }

      if (data.hint !== null) {
        $el.find(".form-control-feedback").html(data.hint);
      }
    }

    if (data.disable === true) {
      $el.find("input[type=\"radio\"]").each(function(i, e) {
        $(e).prop("disabled", true);
      });
    }

    if (data.enable === true) {
      $el.find("input[type=\"radio\"]").each(function(i, e) {
        $(e).prop("enabled", false);
      });
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");
