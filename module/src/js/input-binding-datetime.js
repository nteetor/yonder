var datetimeInputBinding = new Shiny.InputBinding();

$.extend(datetimeInputBinding, {
  Selector: {
    SELF: ".dull-datetime-input"
  },
  initialize: function(el) {
    let $input = $("input", el);
    let config = {};

    if ($input.data("mode") === "multiple" && !$input.data("alt-format")) {
      config.altFormat = "M j, Y";
      config.conjunction = "; ";
    }

    if ($input.data("default-date") &&
        ($input.data("mode") === "range" || $input.data("mode") === "multiple")) {
      config.defaultDate = $input.data("default-date").split("\\,");
      $input.removeAttr("data-default-date");
    }

    $input.flatpickr(config);
  },
  getType: () => "dull.datetime",
  getValue: function(el) {
    return $("input", el).get(0)._flatpickr.selectedDates;
  },
  subscribe: (el, callback) => {
    $(el).on("change.datetimeInputBinding", "input", (e) => {
      callback();
    });
  },
  unsubscribe: (el) => $(el).off(".datetimeInputBinding"),
  receiveMessage: function(el, msg) {
    console.error("receiveMessage: not implemented for datetime input");
    return;
  }
});

Shiny.inputBindings.register(datetimeInputBinding, "dull.datetimeInput");
