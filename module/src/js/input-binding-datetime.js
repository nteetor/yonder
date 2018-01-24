var datetimeInputBinding = new Shiny.InputBinding();

$.extend(datetimeInputBinding, {
  find: function(scope) {
    return $(".dull-datetime-input[id]", scope);
  },
  initialize: function(el) {
    let $input = $("input", el);
    $input.flatpickr();
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
