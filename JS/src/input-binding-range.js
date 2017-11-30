var rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-range-input[id]");
  },
  initialize: function(el) {
    var $input = $("input[type='text']", el);

    $input.ionRangeSlider();
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var data = $("input[type='text']", el).data("ionRangeSlider") || {};

    if (!data) {
      return null;
    }

    return data.result;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.rangeInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".rangeInputBinding");
  }
});

Shiny.inputBindings.register(rangeInputBinding, "dull.rangeInput");
