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
  this.getType = function(el) {
    if ($(el).parents(".dull-form-input[id]").length) {
      return "dull.form.element";
    }
  };
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

$.extend(alertInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-alert[id] .close").parent();
  },
  getValue: function(el) {
    var ret = $(el).data("closed") || null;
    return ret;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("closed.bs.alert.alertInputBinding", function(e) {
      $(el).data("closed", true);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".alertInputBinding");
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

var buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-button-group-input[id]");
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
  find: function(scope) {
    return $(scope).find(".dull-button-input[id]");
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
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.label !== undefined) {
      $el.html(data.label);
    }

    if (data.reset === true) {
      $el.data("clicks", 0);
    }

    if (data.disable === true) {
      $el.prop("disabled", true);
    }

    if (data.enable === true) {
      $el.prop("disabled", false);
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");

var checkbarInputBinding = new Shiny.InputBinding();

$.extend(checkbarInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-checkbar-input[id]");
  },
  getValue: function(el) {
    return $(el).find("input[type=checkbox]:checked")
      .map((i, e) => $(e).data("value"))
      .get();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.checkbarInputBinding", function(e) {
      callback();
    });
    $(el).on("change.checkbarInputBinding", function(e) {
      callback();
    });
  },
  unsubcribe: function(el) {
    $(el).off(".checkbarInputBinding");
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "checkbarInput");

var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function(scope){
    return $(scope).find(".dull-checkbox-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .find("input[type='checkbox']:checked:not(:disabled)")
      .data("value");
    return $val === undefined ? null : $val;
  },
  _getLabel: function(el) {
    return $(el).find(".custom-control-description").text();
  },
  getState: function(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.checkboxInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

     if (data.validate !== undefined) {
      $("input", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("input", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }

    if (data.content !== undefined) {
      $el.find("label").remove();
      $el.html(data.choice);
    }

    if (data.disable === true) {
      $el.find("input[type=\"checkbox\"]").prop("disabled", true);
      if ($el.find(".form-gruop").hasClass("disabled")) {
        $el.find(".form-group").addClass("disabled");
      }
    }

    if (data.enable === true) {
      $el.find("input[type=\"checkbox\"]").prop("disabled", false);
      $el.find(".form-group").removeClass("disabled");
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");

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

$(document).ready(function() {
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item", function(e) {
    e.preventDefault();
  });
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item:not(.disabled)", function(e) {
    $(this).trigger("click:item", {
      value: $(this).data("value")
    });
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown-input[id]");
  },
  getValue: function(el) {
    var $value = $(el).data("value");

    return $value === undefined ? null : $value;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click:item.dropdownInputBinding", function(e, data) {
      $(el).data("value", data.value);
      callback();
    });
    $(el).on("change.dropdownInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.disable) {
      if (data.disable === true) {
        $el.find(".dropdown-toggle").prop("disabled", true);
        $el.data("value", null);
      } else {
        $.each(data.disable, function(i, v) {
          var $item = $el.find(".dropdown-item[data-value=\"" + v + "\"]");

          if ($item.length !== 0 && !$item.hasClass("disabled")) {
            $item.addClass("disabled");
          }

          if (v == $el.data("value")) {
            $el.data("value", null);
          }
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find(".dropdown-toggle").prop("disabled", false);
        $el.find(".dropdown-item").removeClass("disabled");
      } else {
        $.each(data.enable, function(i, v) {
          var $item = $el.find(".dropdown-item[data-value=\"" + v + "\"]");
          if ($item.length !== 0) {
            $item.removeClass("disabled");
          }
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");

var formInputBinding = new Shiny.InputBinding();

$(document).ready(function() {
  $(".dull-form-input[id]").each(function(i, el) {
    $(el).find(".dull-input[id]").each(function(j, e) {
      $(e).data("id", e.id)
        .attr("id", el.id + "__" + e.id)
        .data("parent-form", el.id);
    });
  });
});

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function(el) {
    var value = $(el).find(".dull-input[id]")
      .map(function() {
        let obj = {};

        let v = Shiny.shinyapp.$inputValues[this.id + ":dull.form.element"];
        if (v === undefined) {
          return obj;
        }

        obj[$(this).data("id")] = v;

        return obj;
      })
      .get()
      .reduce((acc, obj) => Object.assign(acc, obj));

    if (Object.keys(value).length === 0) {
      return null;
    }

    return value;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("submit.formInputBinding", function(e) {
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
  find: function(scope) {
    return $(scope).find(".dull-group-input[id]");
  },
  initialize: function(el) {
    var $el = $(el);

    $el.data("prefix", $el.find(".left-addon")
      .map((i, e) => $(e).text())
      .get()
      .join("")
    );

    $el.data("suffix", $el.find(".right-addon")
      .map((i, e) => $(e).text())
      .get()
      .join("")
    );
  },
  getValue: function(el) {
    var $el = $(el);

    var text = $el.find("input[type=\"text\"]").val();

    if (text === "") {
      return null;
    }

    var left = $el.find(".left-group .dull-dropdown-input[id]").data("value") || "";
    var right = $el.find(".right-group .dull-dropdown-input[id]").data("value") || "";

    return left + $el.data("prefix") + text + $el.data("suffix") + right;
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var $el = $(el);
    if ($el.find("button").length) {
      $el.on("click.groupInputBinding", ".dull-button-input[id]", function(e) {
        callback();
      });
      $el.on("click.groupInputBinding", ".dull-dropdown-input[id] .dropdown-item", function(e) {
        callback();
      });
    } else {
      $el.on("change.groupInputBinding", function(e) {
        callback();
      });
    }
  },
  unsubscribe: function(el) {
    $(el).off(".groupInputBinding");
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");

// $(document).ready(() => {
//   $(".dull-list-group-input[id]").on("click", ".list-group-item:not(.disabled)", function(e) {
//     e.preventDefault();

//     let $this = $(this);
//     $this.toggleClass("active");
//     $this.trigger("change");
//   });
// });

// var listGroupInputBinding = new Shiny.InputBinding();

// $.extend(listGroupInputBinding, {
//   find: function(scope) {
//     return $(scope).find(".dull-list-group-input[id]");
//   },
//   getValue: function(el) {
//     var $val = $(el)
//       .children(".list-group-item.active:not(:disabled)")
//       .map(function(i, e) {
//         return $(e).data("value");
//       })
//       .get();
//     return $val === undefined ? null : $val;
//   },
//   getState: function(el, data) {
//     return { value: this.getValue(el) };
//   },
//   subscribe: function(el, callback) {
//     $(el).on("change.listGroupInputBinding", function(e) {
//       callback();
//     });
//   },
//   unsubscribe: function(el) {
//     $(el).off(".listGroupInputBinding");
//   },
//   receiveMessage: function(el, data) {
//     var $el = $(el);

//     if (data.items !== undefined) {
//       $el.find(".list-group-item").remove();
//       if ($el.children().length !== 0) {
//         $el.children().first().before(data.items);
//       } else {
//         $el.html(data.items);
//       }
//     }

//     if (data.disable) {
//       if (data.disable === true) {
//         $el.find(".list-group-item").each(function(i, e) {
//           $(e).prop("disabled", true);
//         });
//       } else {
//         $.each(data.disable, function(i, v) {
//           $el.find(".list-group-item[data-value=\"" + v + "\"]")
//             .prop("disabled", true);
//         });
//       }
//     }

//     if (data.enable) {
//       if (data.enable === true) {
//         $el.find(".list-group-item").each(function(i, e) {
//           $(e).prop("disabled", false);
//         });
//       } else {
//         $.each(data.enable, function(i, v) {
//           $el.find(".list-group-item[data-value=\"" + v + "\"]")
//             .prop("disabled", false);
//         });
//       }
//     }

//     if (data.increment) {
//       if (data.increment === true) {
//         var $badge = $el.find(".list-group-item .badge");

//         if ($badge.length !== 0) {
//           $badge.each(function(i, e) {
//             $(e).text(parseInt($(e).text(), 10) + 1);
//           });
//         }
//       } else {
//         $.each(data.increment, function(i, v) {
//           var $badge = $el.find(".list-group-item[data-value=\"" + v + "\"] .badge");

//           if ($badge.length !== 0) {
//             $badge.text(parseInt($badge.text(), 10) + 1);
//           }
//         });
//       }
//     }

//     $el.trigger("change");
//   }
// });

// Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");

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
  find: function(scope) {
    return $(scope).find(".dull-radio-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .find("input[type=\"radio\"]:checked:not(:disabled)")
      .data("value");
    return $val === undefined ? null : $val;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.radioInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".radioInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.validate !== undefined) {
      $("input", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("input", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }

    if (data.choices !== undefined) {
      $el.find(".custom-radio").remove();
    }

    if (data.disable) {
      if (data.disable === true) {
        $el.find("input[type=\"radio\"]").each(function(i, e) {
          $(e).prop("disabled", true);
        });
      } else {
        $.each(data.disable, function(i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]")
            .prop("disabled", true);
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find("input[type=\"radio\"]").each(function(i, e) {
          $(e).prop("disabled", false);
        });
      } else {
        $.each(data.enable, function(i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]")
            .prop("disabled", false);
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");

var radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radiobar-input[id]");
  },
  getValue: function(el) {
    return $(el).find("input[type=radio]:checked").data("value");
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
  find: function(scope) {
    return $(scope).find(".dull-range-input[id]");
  },
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
  subscribe: function(el, callback) {
    $(el).on("change.rangeInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".rangeInputBinding");
  },
  dispose: function(el) {
    var $input = $("input[type='text']", el);

    $input.data("ionRangeSlider").destroy();
  }
});

Shiny.inputBindings.register(rangeInputBinding, "dull.rangeInput");

var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-select-input[id]");
  },
  getValue: function(el) {
    return $(el)
      .find("option:checked")
      .map(function(i, e) {
        var $val = $(e).data("value");
        return $val === undefined ? null : $val;
      })
      .get();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var self = this;
    $(el).on("change.selectInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".selectInputBinding");
  },
  receiveMessage: function(el, data) {
    if (data.validate !== undefined) {
      $("select", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("select", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }
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
      .filter((i, e) => $(e).data("selected"))
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
    var $this = $(this);

    if ($this.data("selected")) {
      $this.data("selected", false).attr("class", function(i, c) {
        c = c || "";
        var d = c.replace(/bg-(primary|success|info|warning|danger)/g, "table-$1")
          .replace(/table-dark/g, "");

        return d;
      });
    } else {
      $this.data("selected", true).attr("class", function(i, c) {
        c = c || "";
        var d = c.replace(/table-(primary|success|info|warning|danger)/g, "bg-$1");

        if (d === c) {
          d = d + " table-dark";
        }

        return d;
      });
    }
  });
});

var textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-textual-input[id]");
  },
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
  },
  subscribe: function(el, callback) {
    $(el).on("change.textualInputBinding", function(e) {
      callback(true);
    });
    $(el).on("input.textualInputBinding", function(e) {
      callback(true);
    });

  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  },
  receiveMessage: function(el, data) {
    if (data.validate !== undefined) {
      $("input", el).removeClass("is-invalid")
        .addClass("is-valid");

      return;
    }

    if (data.invalidate !== undefined) {
      $("input", el).addClass("is-invalid");
      $(".invalid-feedback", el).html(data.invalidate);

      return;
    }
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
  $(".dull-list-group-thruput[id]").on("click", ".list-group-item:not(.disabled)", (e) => {
    e.preventDefault();

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
    $(el)
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
    console.log(data);
    $(el).append(
      $.map(data.values, (val, i) => $("<a class='list-group-item'>" + val + "</a>"))
    );
  }
});

Shiny.outputBindings.register(listGroupOutputBinding, "dull.listGroupOutput");
