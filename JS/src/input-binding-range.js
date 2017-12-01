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
    var $input = $("input[type='text']", el);
    var data = $input.data("ionRangeSlider") || {};

    if (!data) {
      return null;
    }

    if ($input.data("type") == "double") {
      return [data.result.from, data.result.to];
    }

    return data.result.from;
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
