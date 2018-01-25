var datetimeInputBinding = new Shiny.InputBinding();

$.extend(datetimeInputBinding, {
  find: function(scope) {
    return $(".dull-datetime-input[id]", scope);
  },
  initialize: function(el) {
    let $input = $("input", el);
    let config = {};
    
    if ($input.data("mode") === "range" && $input.data("default-date")) {
      config.defaultDate = $input.data("default-date").split("\\,");
      console.log(config);
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
