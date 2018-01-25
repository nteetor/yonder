var datetimeInputBinding = new Shiny.InputBinding();

$.extend(datetimeInputBinding, {
  find: function(scope) {
    return $(".dull-datetime-input[id]", scope);
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
  unsubscribe: (el) => $(el).off(".datetimeInputBinding")
});

Shiny.inputBindings.register(datetimeInputBinding, "dull.datetimeInput");
