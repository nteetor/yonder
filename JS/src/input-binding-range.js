var rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-range-input[id]");
  },
  initialize: function(el) {
    var $input = $("input[type='text']", el);

    if ($input.data("choices") !== undefined) {
      this.choices = $input.data("choices").split("\\,");
    }

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
      return {
        from: data.result.from,
        to: data.result.to
      };
    } else if ($input.data("type") == "single") {
      if (this.choices) {
        return this.choices[data.result.from];
      } else {
        return data.result.from;
      }
    }
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
  },
  dispose: function(el) {
    var $input = $("input[type='text']", el);

    $input.data("ionRangeSlider").destroy();
  }
});

Shiny.inputBindings.register(rangeInputBinding, "dull.rangeInput");
