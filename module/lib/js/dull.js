$(function() {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(function() {
  $("[data-toggle=\"popover\"]").popover();
});

$(function() {
  $(".nav:not([role='tablist']) li").on("click", function(e) {
    var $this = $(this);
    $(".nav-link", $this.parent(".nav")).removeClass("active");
    $(".nav-link", $this).addClass("active");
  });
});

$(document).on("shiny:connected", function() {
  $(".dull-submit[data-type=\"submit\"]").attr("type", "submit");
});

$(function() {
  Shiny.addCustomMessageHandler("dull:collapse", function(msg) {
  	var $el = $("#" + msg.id);

  	if ($el.length === 0 || !msg.action) {
  	    return false;
  	}

  	$el.collapse(msg.action);
  });

  Shiny.addCustomMessageHandler("dull:download", function(msg) {
    var uri = "/session/" + msg.token + "/download/" + msg.name;

    $.get(uri, function() {
      window.location = uri;
    })
    .fail(function() {
      alert("An error occurred during download.");
    });
  });
});

Shiny.addCustomMessageHandler("dull:alert", function(msg) {
  var ids = msg.id.map(v => "#" + v).join(",");

  $("<div>")
    .addClass("alert alert-dismissible fade show")
    .html(msg.content)
    .append(
      $("<button>", {
        "type": "button",
        "class": "close",
        "data-dismiss": "alert",
        "aria-label": "Close"
      }).append(
        $("<span>", {
          "class": "fas fa-window-close",
          "aria-hidden": true
        })
      )
    )
    .insertBefore($(ids));
});

(function() {
  this.find = function(scope) {
    return $(scope).find(`${ this.Selector.SELF }[id]`);
  };

  this.getId = function(el) {
    return el.id;
  }

  this.getType = function(el) {
    return false;
  };

  // may not be worth it to have this method already created
  this.getValue = function(el) {
    let values = $(el).find(`${ this.Selector.SELECTED }`)
        .map((i, e) => {
          let $e = $(e);

          if ($e.is("[data-value]")) {
            return $e.data("value");
          }

          if ($e.is("input")) {
            return $e.val();
          }

          return $e.text();
        })
        .get();

    return values === undefined ? null : values;
  };

  this.subscribe = function(el, callback) {
    if (this.isFormElement(el)) {
      $(el).closest(".dull-form-input[id]").on("submit", e => callback());
    } else {
      for (const event of (this.Events || [])) {
        $(el).on(`${ event.type }.dull`, (e) => {
          callback(event.debounce || false);
        });
      }
    }
  };

  this.unsubscribe = function(el) {
    $(el).off("dull");
  };

  this.updateChoices = function(el, map) {
    if (this.Selector.VALUE === this.Selector.SELF) {
      let value = map[$(el).data("value")];

      if (value !== undefined) {
        $(el).html(value);
      }

      return;
    }

    let $inputs = $(el).find(`${ this.Selector.VALUE }`);
    let $labels = $(el).find(`${ this.Selector.LABEL }`);

    if ($inputs.length != $labels.length) {
      console.error("updateChoices: mismatched number of inputs and labels");
      return;
    }

    $inputs.each((index, input) => {
      let $input = $(input);
      let $label = $($labels.get(index));

      let value = map[$input.data("value")];

      if (value !== undefined) {
        $label.html(value);
      }
    });
  }

  this.updateValues = function(el, map) {
    if (typeof map == "string" || Array.isArray(map)) {
      let $inputs = $(el).find(`${ this.Selector.VALUE }`);
      let value = typeof map == "string" ? [map] : map;

      if ($inputs.has(":not(input[type='text'])").length) {
        console.error("updateValues: expecting all inputs to be text if new values are unnamed");
        return;
      }

      if ($inputs.length != value.length) {
        console.error("updateValues: mismatched number of inputs and values");
        return;
      }

      $inputs.each((index, input) => {
        let $input = $(input);
        $input.val(value[index]);
        $input.trigger("change");
      });

      return;
    }

    if (this.Selector.VALUE === this.Selector.SELF) {
      let value = map[$input.data("value")];

      if (value !== undefined) {
        $input.data("value", value);
      }

      return;
    }

    let $inputs = $(el).find(`${ this.Selector.VALUE }`);

    $inputs.each((index, input) => {
      let $input = $(input);

      let value = map[$input.data("value")];

      if (value !== undefined) {
        $input.data("value", value);
      }
    });
  }

  this.markValid = function(el, data) {
    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-invalid").addClass("is-valid");
    let $feedback = $(el).find(".valid-feedback");
    if ($feedback.length) {
      $feedback.text(data.msg);
    }
  }

  this.markInvalid = function(el, data) {
    let $input = $(el).find(this.Selector.VALIDATE);
    $input.removeClass("is-valid").addClass("is-invalid");
    let $feedback = $(el).find(".invalid-feedback");
    if ($feedback) {
      $feedback.text(data.msg);
    }
  }

  this.receiveMessage = function(el, msg) {
    if (!msg.type) {
      return;
    }

    let [action, type = null] = msg.type.split(":");

    if (action === "update") {
      if (!type || msg.data === undefined) {
        throw "Invalid update message"
      }

      if (type === "choices") {
        this.updateChoices(el, msg.data);
      }

      if (type === "values") {
        this.updateValues(el, msg.data);
      }

      return;
    }

    if (action === "mark") {
      if (this.Selector.VALIDATE === undefined) {
        return;
      }

      if (type === "valid") {
        this.markValid(el, msg.data);
      }

      if (type === "invalid") {
        this.markInvalid(el, msg.data);
      }

      return;
    }
  };

  this.isFormElement = function(el) {
    return $(el).parents(".dull-form-input[id]").length > 0;
  }
}).call(Shiny.InputBinding.prototype);

var addressInputBinding = new Shiny.InputBinding();

$.extend(addressInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-address-input[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    var $inputs = $el.find("input");
    var names = ["line1", "line2", "city", "state", "zip"];

    var values = $inputs.map((i, e) => $(e).val())
      .get()
      .reduce(function(acc, val, i) {
        acc[names[i]] = val;
        return acc;
      }, {});

    if (!Object.values(values).reduce((acc, obj) => acc || obj)) {
      return null;
    }

    return values;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.addressInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".addressInputBinding");
  }
});

Shiny.inputBindings.register(addressInputBinding, "dull.addressInput");

var alertInputBinding = new Shiny.InputBinding();

$(() => $("body").append(
  $("<div class='dull-alert-container' id='alert-container'></div>")
));

$.extend(alertInputBinding, {
  Selector: {
    SELF: ".dull-alert-container"
  },
  Alerts: [],
  getValue: function(el) {
    return null;
  },
  subscribe: function(el, callback) {

  },
  unsubscribe: function(el) {

  },
  receiveMessage: function(el, data) {
    let alertAttrs = data.attrs || {};
    let alertClass = data.color ? `alert-${ data.color }` : "";

    let $alert = $(`<div class="alert ${ alertClass } fade show dull-alert" role="alert">${ data.text }</div>`);

    if (data.action) {
      $alert.append($(`<button class="btn btn-link alert-action">${ data.action }</button>`));
      $alert.on("click", ".alert-action", (e) => {
        Shiny.onInputChange(data.action, true);
      });
    }

    Object.entries(alertAttrs).forEach((item) => {
      item[0] == "class" ? $alert.addClass(item[1]) : $alert.attr(...item);
    });

    this.Alerts.push({ el: $alert, action: data.action });

    $alert.appendTo($(this.Selector.SELF))
      .velocity(
        { top: 0, opacity: 1 },
        { duration: 300, easing: "easeOutCubic", queue: false }
      );

    setTimeout(
      () => {
        let item = this.Alerts.shift();

        if (data.action) {
          Shiny.onInputChange(item.action, null);
        }

        item.el.remove()
      },
      data.duration
    );
  }
});

Shiny.inputBindings.register(alertInputBinding, "dull.alertInput");

var breadcrumbOutputBinding = new Shiny.OutputBinding();

$.extend(breadcrumbOutputBinding, {
  find: function(scope) {
    return $(scope).find(".buckle-breadcrumb");
  },
  getValue: function(el) {
    return $(el).find("li:last").text();
  }
});

/* THIS IS A STUB */

let buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  Selector: {
    SELF: ".dull-button-group-input",
    VALUE: ".btn",
    LABEL: ".btn"
  },
  _value: null,
  getValue: function(el) {
    return this._value;
  },
  subscribe: function(el, callback) {
    var self = this;
    $(el).on("click.buttonGroupInputBinding", "button", function(e) {
      self._value = $(this).data("value");
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".buttonGroupInputBinding", "button");
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "dull.buttonGroup");

var buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  Selector: {
    SELF: ".dull-button-input",
    VALUE: ".dull-button-input",
    LABEL: ".dull-button-input"
  },
  getValue: function(el) {
    var $el = $(el);

    if ($el.data("clicks") === 0) {
      return null;
    }

    return parseInt($el.data("clicks"), 10);
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.buttonInputBinding", function(e) {
      var $el = $(el);
      $el.data("clicks", parseInt($el.data("clicks"), 10) + 1);

      callback();
    });
    $(el).on("change.buttonInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".buttonInputBinding");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");

var checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  Selector: {
    SELF: ".dull-checkbar-input",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn.active input"
  },
  Events: [
    { type: "change" },
    { type: "click" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "dull.checkbarInput");

let checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  Selector: {
    SELF: ".dull-checkbox-input",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  getValue: function(el) {
    var $val = $(el)
      .find(`${ this.Selector.SELECTED }`)
      .data("value");
    return $val === undefined ? null : $val;
  },
  _getLabel: function(el) {
    return $(el).find(`${ this.Selector.LABEL }`).text();
  },
  getState: function(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");

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

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  Selector: {
    SELF: ".dull-dropdown-input",
    LABEL: ".dropdown-item",
    VALUE: ".dropdown-item"
  },
  getValue: function(el) {
    return null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {

  },
  unsubscribe: function(el) {

  },
  receiveMessage: function(el) {
    console.error("receiveMessage: not implemented for dropdown input");
    return;
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");

var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function(el) {
    return null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("submit.formInputBinding", (e) => {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");

var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".dull-group-input",
    VALUE: "input",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
  },
  Events: [
    { type: "input", debounce: true },
    { type: "change", debounce: true }
  ],
  getType: function(el) {
    return "dull.group.input";
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");

var loginInputBinding = new Shiny.InputBinding();

$.extend(loginInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-login-input[id]");
  },
  getValue: function(el) {
    var values = $(el).find(".form-control").map((i, e) => $(e).val()).get();

    if (!values[0] && !values[1]) {
      return null;
    }

    return {
      username: values[0],
      password: values[1]
    };
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.loginInputBinding", ".btn", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".loginInputBinding");
  }
});

Shiny.inputBindings.register(loginInputBinding, "dull.loginInput");

var navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-nav[id]");
  },
  getValue: function(el) {
    return $(".nav", el).find(".active").data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("shown.bs.tab.navInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".navInputBinding");
  }
});

Shiny.inputBindings.register(navInputBinding, "dull.navInput");

var radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  Selector: {
    SELF: ".dull-radio-input",
    VALUE: ".custom-control-input",
    LABEL: ".custom-control-label",
    SELECTED: ".custom-control-input:checked:not(:disabled)",
    VALIDATE: ".custom-control-input"
  },
  Events: [
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");

var radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".dull-radiobar-input",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn input:checked"
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.radiobarInputBinding", function(e) {
      callback();
    });
    $(el).on("change.radiobarInputBinding", function(e) {
      callback();
    });
  },
  unsubcribe: function(el) {
    $(el).off(".radiobarInputBinding");
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "radiobarInput");

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
      $el
        .find(".irs-slider,.irs-bar,.irs-bar-edge,.irs-to,.irs-from,.irs-single,.irs-slider")
        .addClass(bgclasses);
    }
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var $input = $("input[type='text']", el);
    var data = $input.data("ionRangeSlider");

    if ($input.data("type") == "double") {
      return {
        from: data.result.from,
        to: data.result.to
      };
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

var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  Selector: {
    SELF: ".dull-select-input",
    VALUE: "option",
    LABEL: "option",
    SELECTED: "option:checked",
    VALIDATE: "select"
  },
  Events: [
    { type: "change" }
  ],
  getState: function(el, data) {
    return { value: this.getValue(el) };
  }
});

Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");

var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function(el) {
    return el.id;
  },
  getType: function(el) {
    return "dull.table.input";
  },
  getValue: function(el) {
    var $el = $(el);

    var columns = $el.find("thead th").map((i, e) => $(e).text()).get();

    var value = $el.find("tr")
      .filter((i, e) => $(e).hasClass("table-active"))
      .map(function(i, row) {
        var obj = {};

        $(row).children("td").each(function(j, cell) {
          obj[columns[j + 1]] = $(cell).text();
        });

        return obj;
      })
      .get();

    return JSON.stringify(value);
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.tableInputBinding", function(e) {
      callback();
    });
    $(el).on("click.tableInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tableInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.validate) {
      $.each(data.validate, function(i, index) {
        $el.find("tbody tr:nth-child(" + index + ")")
          .addClass("table-" + data.state);
      });
    }
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

$(document).ready(function() {
  $(".dull-table-thruput[id]").on("click", "tbody tr", function(e) {
    $(this).toggleClass("table-active");
  });
});

var textualInputBinding = new Shiny.InputBinding();

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

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");

Shiny.addCustomMessageHandler("dull:modal", function(msg) {
  if (msg.close === true) {
    $(".modal").modal("hide");
    return true;
  }

  var $modal;

  if ($(".modal").length) {
    $modal = $(".modal");
  } else {
    $modal = $([
      "<div class='modal fade' tabindex=-1 role='dialog'>",
      "<div class='modal-dialog' role='document'>",
      "<div class='modal-content'>",
      "<div class='modal-header'>",
      "<h5 class='modal-title'></h5>",
      "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>",
      "<span class='fa fa-times-rectangle'></span>",
      "</button>",
      "</div>",
      "<div class='container-fluid'>",
      "<div class='modal-body'></div>",
      "</div>",
      "</div>",
      "</div>",
      "</div>"
    ].join("\n"));

    $("body").append($modal);
  }


  $(".modal-title", $modal).html(msg.title);
  $(".modal-body", $modal).html(msg.body);

  if (msg.footer) {
    if (!$(".modal-footer", $modal).length) {
      $(".modal-content", $modal).append($("<div class='modal-footer'></div>"));
    }

    $(".modal-content", $modal).html(msg.footer);
  }

  $modal.modal();
});

$(document).ready(function() {
  $(document).on("shown.bs.modal", ".modal", function(e) {
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });
});

var badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-badge-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.value !== null && data.value !== undefined) {
      $el.text(data.value);
    }
  },
  renderError: function(el, data) {

  },
  clearError: function(el) {

  }
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");

var chartistOutputBinding = new Shiny.OutputBinding();

$.extend(chartistOutputBinding, {

});

//Shiny.outputBindings.register(chartistOutputBinding, "dull.chartistOutput");

$.extend(Shiny.progressHandlers, {
  "dull-progress": function(msg) {
    var $bar = $(".dull-progress-output #" + msg.id);

    $bar.attr("style", function(i, s) {
        return s.replace(/width: [0-9]+%/, "width: " + msg.value + "%");
      })
      .attr("aria-valuenow", msg.value);

    if (msg.label) {
      $bar.text(msg.label);
    }

    if (msg.context) {
      $bar.attr("class", function(i, c) {
        return c.replace(/bg-(?:primary|secondary|success|info|warning|danger|light|dark|white)/g, "bg-" + msg.context);
      });
    }
  }
});

var radialOutputBinding = new Shiny.OutputBinding();

$.extend(radialOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radial-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var dat = [30, 86, 168, 281, 303, 365];

    d3.select(".chart")
      .selectAll("div")
      .data(dat)
        .enter()
        .append("div")
        .style("width", function(d) { return d + "px"; })
        .text(function(d) { return d; });
  }
});

Shiny.outputBindings.register(radialOutputBinding, "dull.radialOutput");

var sparklineOutputBinding = new Shiny.OutputBinding();

$.extend(sparklineOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-sparkline-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    if (data.values !== undefined) {
      var $el = $(el);

      var labels = $el.data("labels");

      $el.text(function(i, c) {
        var contents = "{" + data.values.join(",") + "}";

        // if (labels) {
        //   contents = data.raw[0] + contents + data.raw[data.raw.length - 1];
        // }

        if (c === "") {
          return contents;
        } else {
          return c.replace(/{[0-9,]*}/, contents);
        }
      });
    }
  },
  renderError: function(el, data) {

  },
  clearError: function(el) {

  }
});

Shiny.outputBindings.register(sparklineOutputBinding, "dull.sparklineOutput");

$.extend(Shiny.progressHandlers, {
  "dull-spinner": function(msg) {
    var $spinner = $("#" + msg.id);

    if (!$spinner.is(".dull-spinner-output")) {
      return false;
    }

    if (msg.action === "start") {
      $spinner.removeClass("pause");
    }

    if (msg.action == "stop") {
      $spinner.addClass("pause");
    }
  }
});

$.extend(Shiny.progressHandlers, {
  "dull-stream": function(data) {
    $("<li class='list-group-item'></li>")
      .text(data.content)
      .hide()
      .appendTo($("#" + data.id))
      .fadeIn(300);

    return false;
  }
});

var tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);
    var context = $el.data("table");

    if (data.data && data.columns) {
      $el.empty();

      $el.append(
        $("<thead>").append(
          $("<tr>", {
            "class": context
          }).append(
            $("<th>").text("#"),
            $.map(data.columns, (col, i) => {
              return $("<th>").addClass("thead-default").text(col);
            })
          )
        ),
        $("<tbody>").append(
          $.map(data.data, (row, i) => {
            var heading;
            if ("_row" in row) {
              heading = $("<th>").text(row._row).attr("scope", "row");
              delete row._row;
            } else {
              heading = $("<th>").text(i + 1).attr("scope", "row");
            }

            return $("<tr>", {
              "color": context
            }).append(
              heading,
              $.map(Object.entries(row), ([key, value], i) => {
                return $("<td>").text(value).data("col", key);
              })
            );
          })
        )
      );
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");

/**
 * WORK IN PROGRESS
 */

var tooltipBinding = new Shiny.OutputBinding();

$.extend(tooltipBinding, {
  find: function(scope) {
    return null;
  },
  getId: function(el) {
    return null;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.remove) {
      $el.removeAttr("data-toggle");
      $el.removeAttr("data-placement");
      $el.removeAttr("title");

      return false;
    }

    if (data.show) {

    }

  }
});

//Shiny.outputBindings.register(tooltipBinding, "dull.tooltip");

$(() => {
  $(".dull-list-group-thruput[id]").on("click", ".list-group-item:not(.disabled)", function(e) {
    e.preventDefault();

    let $parent = $(this).closest(".dull-list-group-thruput");

    if (!$parent.data("multiple")) {
      $parent.children(".list-group-item.active").removeClass("active");
    }

    $(this).toggleClass("active")
      .trigger("change");
  });
});

// input
let listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: (scope) => $(scope).find(".dull-list-group-thruput[id]"),

  getId: (el) => el.id,

  getValue: (el) => {
    return $(el)
      .children(".list-group-item.active:not(.disabled)")
      .map((index, item) => $(item).data("value"))
      .get();
  },

  getState: (el, data) => ({ value: this.getValue(el) }),

  subscribe: (el, callback) => {
    $(el).on("change.listGroupInputBinding", (e) => callback());
  },

  unsubscribe: (el) => $(el).off(".listGroupInputBinding")
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");

// output
let listGroupOutputBinding = new Shiny.OutputBinding();

$.extend(listGroupOutputBinding, {
  find: (scope) => $(scope).find(".dull-list-group-thruput[id]"),

  getId: (el) => el.id,

  renderValue: (el, data) => {
    if (data.items) {
      let items = data.items.join("\n");

      Shiny.renderContent(el, items);
    }
  }
});

Shiny.outputBindings.register(listGroupOutputBinding, "dull.listGroupOutput");
