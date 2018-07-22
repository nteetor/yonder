export let textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  Selector: {
    SELF: ".dull-textual-input",
    VALIDATE: "input"
  },
  Events: [
    { type: "change", debounce: true },
    { type: "input", debounce: true }
  ],
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
  }
});

// Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");
