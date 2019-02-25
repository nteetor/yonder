export let rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  Selector: {
    SELF: ".yonder-range[id]"
  },
  Events: [
    { type: "change" }
  ],
  initialize: (el) => {
    $(el.querySelector("input")).ionRangeSlider();
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var $input = $("input[type='text']", el);
    var data = $input.data("ionRangeSlider");

    if ($input.data("type") === "double") {
      return [data.result.from, data.result.to];
    } else if ($input.data("type") === "single") {
      if (data.result.from_value !== null) {
        return data.result.from_value.replace("&#44;", ",");
      } else {
        return data.result.from;
      }
    } else {
      return null;
    }
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  _update: (el, data) => {
    $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider").update({
      values: data.values
    });
  },
  _select: (el, data) => {
    $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider");
    // need to check if input is a numeric range input or choices slider
  },
  dispose: function(el) {
    $(el.querySelector(".irs-hidden-input")).data("ionRangeSlider").destroy();
  }
});

Shiny.inputBindings.register(rangeInputBinding, "yonder.rangeInput");
