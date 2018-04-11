var rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {
  Selector: {
    SELF: ".dull-range-input"
  },
  Events: [
    { type: "change" }
  ],
  initialize: (el) => {
    let $el = $(el);
    let $input = $el.find("input[type='text']");

    $input.ionRangeSlider();

    let bgclasses = $el.attr("class")
        .split(/\s+/)
        .filter(c => /^bg-[a-z-]+|(lighten|darken)-[1234]/.test(c))
        .join(" ");

    if (bgclasses) {
      $el.find(".irs-slider,.irs-bar,.irs-bar-edge,.irs-to,.irs-from,.irs-single,.irs-slider")
        .addClass(bgclasses);
    }

    if ($input.data("no-fill")) {
      $el.find(".irs-bar,.irs-bar-edge").addClass("no-fill");
    }
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var $input = $("input[type='text']", el);
    var data = $input.data("ionRangeSlider");

    if ($input.data("type") == "double") {
      return [data.result.from, data.result.to];
    } else if ($input.data("type") == "single") {
      if (data.result.from_value !== null) {
        return data.result.from_value.replace("&#44;", ",");
      } else {
        return data.result.from;
      }
    }
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  receiveMessage: function(el, msg) {
    console.error("receiveMessage: not implemented for range input");
    return;
  },
  dispose: function(el) {
    var $input = $("input[type='text']", el);

    $input.data("ionRangeSlider").destroy();
  }
});

Shiny.inputBindings.register(rangeInputBinding, "dull.rangeInput");
