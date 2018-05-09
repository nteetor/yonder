var dateInputBinding = new Shiny.InputBinding();

$.extend(dateInputBinding, {
  Selector: {
    SELF: ".dull-date-input"
  },
  Events: [
    { type: "dateinput:close" }
  ],
  initialize: function(el) {
    let data = el.dataset;
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
  getType: () => "dull.date",
  getValue: (el) => el._flatpickr.selectedDates,
  receiveMessage: function(el, msg) {
    if (msg.type === null) {
      return;
    }

    throw "receiveMessage not implemented for date inputs";
  }
});

Shiny.inputBindings.register(dateInputBinding, "dull.dateInput");
