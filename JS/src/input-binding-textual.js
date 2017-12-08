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
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  _markInvalid: function(el, msg) {
    $("input", el).addClass("is-invalid");
  },
  _markValid: function(el, msg) {
    $("input", el).removeClass("is-invalid").addClass("is-valid");
  },
  subscribe: function(el, callback) {
    var that = this;
    $(el).on("change.textualInputBinding", function(e) {
      callback(true);
    });
    $(el).on("input.textualInputBinding", function(e) {
      callback(true);
    });
    $(el).on("dull:invalid.textualInputBinding", function(e, msg) {
      console.log(msg);
      that._markInvalid(el, msg);
    });
    $(el).on("dull:valid.textualInputBinding", function(e, msg) {
      that._markValid(el, msg);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");
