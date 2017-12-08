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

    if (data.validate !== undefined) {
      $("input", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("input", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }

    if (data.choices !== undefined) {
      $el.find(".custom-radio").remove();
    }

    if (data.disable) {
      if (data.disable === true) {
        $el.find("input[type=\"radio\"]").each(function(i, e) {
          $(e).prop("disabled", true);
        });
      } else {
        $.each(data.disable, function(i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]")
            .prop("disabled", true);
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find("input[type=\"radio\"]").each(function(i, e) {
          $(e).prop("disabled", false);
        });
      } else {
        $.each(data.enable, function(i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]")
            .prop("disabled", false);
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");
