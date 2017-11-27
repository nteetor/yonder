var rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-range-input[id]");
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    return parseInt($("input[type='range']", el).val());
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.rangeInputBinding", function(e) {
      callback(true);
    });
    $(el).on("input.rangeInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".rangeInputBinding");
  }
});

Shiny.inputBindings.register(rangeInputBinding, "dull.rangeInput");
