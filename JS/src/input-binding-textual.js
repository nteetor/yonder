var textInputBinding = new Shiny.InputBinding();

$.extend(textInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-text[id]");
  },
  getValue: function(el) {
    return $(el).val();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  }
});

Shiny.inputBindings.register(textInputBinding, "dull.textInput");

var textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-textual[id]");
  },
  getValue: function(el) {
    return $el.find("input").val();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textualInputBinding", function(e) {
      callback(false);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  },
  getRatePolicy: function() {
    return {
      policy: 'debounce',
      delay: 250
    };
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");
