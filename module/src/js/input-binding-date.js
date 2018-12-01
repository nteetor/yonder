export let dateInputBinding = new Shiny.InputBinding();

$.extend(dateInputBinding, {
  Selector: {
    SELF: ".yonder-date"
  },
  Events: [
    { type: "dateinput:close" }
  ],
  initialize: function(el) {
    let data = $(el).data();
    let config = {
      onClose: (selected, str, inst) => $(el).trigger("dateinput:close")
    };

    if (data.mode === "multiple" && data.altFormat === "alt-format") {
      config.altFormat = "M j, Y";
      config.conjunction = "; ";
    }

    if (data.defaultDate && (data.mode === "range" || data.mode === "multiple")) {
      config.defaultDate = data.defaultDate.split("\\,");
      el.removeAttribute("data-default-date");
    }

    if (data.enable) {
      config.enable = data.enable.split("\\,");
      el.removeAttribute("data-enable");
    }

    flatpickr(el, config);
  },
  getType: () => "yonder.date",
  getValue: (el) => el._flatpickr.selectedDates,
  _update: function(el, data) {
    if (data.selected) {
      el._flatpickr.setDate(data.selected, true);
    }
  },
  _enable: function(el, data) {
    el._flatpickr.set("enable", data.values);
  },
  _disable: function(el, data) {
    el._flatpickr.set("disable", data.values);
  }
});

Shiny.inputBindings.register(dateInputBinding, "yonder.dateInput");
