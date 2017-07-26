var textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-textual[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    var $val = $el.val() || null;

    if ($val === null) {
      return null;
    }

    if ($el.attr("type") === "number") {
      return parseInt($val, 10);
    }

    return $val;
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
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");
