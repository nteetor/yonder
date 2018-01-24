var textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-textual-input[id]");
  },
  getValue: function(el) {
    var $input = $(el).find("input");
    var val = $input.val() === undefined ? null : $input.val();

    if (val === null) {
      return null;
    }

    if ($input.attr("type") === "number") {
      return parseInt(val, 10);
    }

    return val;
  },
  getType: function(el) {
    var $type = $("input", el).attr("type");

    if ($type === "date") {
      return "dull.date.input";
    } else if ($type === "time") {
      return "dull.time.input";
    }

    return false;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textualInputBinding", function(e) {
      callback(true);
    });
    $(el).on("input.textualInputBinding", function(e) {
      callback(true);
    });

  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  },
  receiveMessage: function(el, data) {
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
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");
