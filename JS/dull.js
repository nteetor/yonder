"use strict";

var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

$(function () {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(function () {
  $("[data-toggle=\"popover\"]").popover();
});

$(document).on("shiny:connected", function () {
  $(".dull-submit[data-type=\"submit\"]").attr("type", "submit");
});

Shiny.addCustomMessageHandler("dull:collapse", function (msg) {
  var $el = $("#" + msg.id);

  if ($el.length === 0 || !msg.action) {
    return false;
  }

  $el.collapse(msg.action);
});

Shiny.addCustomMessageHandler("dull:alert", function (msg) {
  console.log(msg.id);
  var ids = msg.id.map(function (v) {
    return "#" + v;
  }).join(",");

  $("<div>").addClass("alert alert-dismissible alert-" + msg.context + " fade show").html(msg.content).append($("<button>", {
    "type": "button",
    "class": "close",
    "data-dismiss": "alert",
    "aria-label": "Close"
  }).append($("<span>", {
    "class": "fa fa-times-rectangle",
    "aria-hidden": true
  }))).insertBefore($(ids));
});

(function () {
  this.getType = function (el) {
    if ($(el).parents(".dull-form-input[id]").length) {
      return "dull.form.element";
    }
  };
}).call(Shiny.InputBinding.prototype);

var addressInputBinding = new Shiny.InputBinding();

$.extend(addressInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-address-input[id]");
  },
  getValue: function getValue(el) {
    var $el = $(el);
    var $inputs = $el.find("input");
    var names = ["line1", "line2", "city", "state", "zip"];

    var values = $inputs.map(function (i, e) {
      return $(e).val();
    }).get().reduce(function (acc, val, i) {
      console.log(i);
      acc[names[i]] = val;
      return acc;
    }, {});

    if (!Object.values(values).reduce(function (acc, obj) {
      return acc || obj;
    })) {
      return null;
    }

    return values;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.addressInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".addressInputBinding");
  }
});

Shiny.inputBindings.register(addressInputBinding, "dull.addressInput");

var alertInputBinding = new Shiny.InputBinding();

$.extend(alertInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-alert[id] .close").parent();
  },
  getValue: function getValue(el) {
    var ret = $(el).data("closed") || null;
    console.log(ret);
    return ret;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("closed.bs.alert.alertInputBinding", function (e) {
      $(el).data("closed", true);
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".alertInputBinding");
  }
});

Shiny.inputBindings.register(alertInputBinding, "dull.alertInput");

var breadcrumbOutputBinding = new Shiny.OutputBinding();

$.extend(breadcrumbOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".buckle-breadcrumb");
  },
  getValue: function getValue(el) {
    return $(el).find("li:last").text();
  }
});

/* THIS IS A STUB */

var buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-button-input[id]");
  },
  getValue: function getValue(el) {
    var $el = $(el);

    if ($el.data("clicks") === 0) {
      return null;
    }

    return parseInt($el.data("clicks"), 10);
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.buttonInputBinding", function (e) {
      var $el = $(el);
      $el.data("clicks", parseInt($el.data("clicks"), 10) + 1);

      callback();
    });
    $(el).on("change.buttonInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".buttonInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.label) {
      $el.html(data.label);
    }

    if (data.reset === true) {
      $el.data("clicks", 0);
    }

    if (data.state) {
      var state = data.state === "valid" ? null : data.state;

      if (state) {
        if ($el.attr("class").search(/btn-outline-/)) {
          state = "btn-outline-" + data.state;
        } else {
          state = "btn-" + data.state;
        }
      }

      $el.attr("class", function (i, c) {
        return c.replace(/btn-(?:outline-)?(?:primary|secondary|link|success|info|warning|danger)/g, "");
      }).addClass(data.state === "valid" ? null : state);
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
  find: function find(scope) {
    return $(scope).find(".dull-checkbar-input[id]");
  },
  getValue: function getValue(el) {
    return $(el).find("input[type=checkbox]:checked").map(function (i, e) {
      return $(e).data("value");
    }).get();
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.checkbarInputBinding", function (e) {
      callback();
    });
    $(el).on("change.checkbarInputBinding", function (e) {
      callback();
    });
  },
  unsubcribe: function unsubcribe(el) {
    $(el).off(".checkbarInputBinding");
  }
});

Shiny.inputBindings.register(checkbarInputBinding, "checkbarInput");

var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-checkbox-input[id]");
  },
  getValue: function getValue(el) {
    var $val = $(el).find("input[type=\"checkbox\"]:checked:not(:disabled)").data("value");
    return $val === undefined ? null : $val;
  },
  _getLabel: function _getLabel(el) {
    return $(el).find(".custom-control-description").text();
  },
  getState: function getState(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.checkboxInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".checkboxInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.content !== undefined) {
      $el.find("label").remove();
      $el.html(data.choice);
    }

    if (data.state) {
      $el.attr("class", function (i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      if (data.state !== "valid") {
        $el.addClass("has-" + data.state);
      }
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

$(document).ready(function () {
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item", function (e) {
    e.preventDefault();
  });
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item:not(.disabled)", function (e) {
    $(this).trigger("click:item", {
      value: $(this).data("value")
    });
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-dropdown-input[id]");
  },
  getValue: function getValue(el) {
    var $value = $(el).data("value");

    return $value === undefined ? null : $value;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click:item.dropdownInputBinding", function (e, data) {
      $(el).data("value", data.value);
      callback();
    });
    $(el).on("change.dropdownInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".dropdownInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.disable) {
      if (data.disable === true) {
        $el.find(".dropdown-toggle").prop("disabled", true);
        $el.data("value", null);
      } else {
        $.each(data.disable, function (i, v) {
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
        $.each(data.enable, function (i, v) {
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

$(document).ready(function () {
  $(".dull-form-input[id]").each(function (i, el) {
    $(el).find(".dull-input[id]").each(function (j, e) {
      $(e).data("id", e.id).attr("id", el.id + "__" + e.id).data("parent-form", el.id);
    });
  });
});

$.extend(formInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-form-input[id]");
  },
  getValue: function getValue(el) {
    var value = $(el).find(".dull-input[id]").map(function () {
      var obj = {};

      var v = Shiny.shinyapp.$inputValues[this.id + ":dull.form.element"];
      if (v === undefined) {
        return obj;
      }

      obj[$(this).data("id")] = v;

      return obj;
    }).get().reduce(function (acc, obj) {
      return Object.assign(acc, obj);
    });

    if (Object.keys(value).length === 0) {
      return null;
    }

    return value;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("submit.formInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");

var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-group-input[id]");
  },
  initialize: function initialize(el) {
    var $el = $(el);

    $el.data("prefix", $el.find(".left-addon").map(function (i, e) {
      return $(e).text();
    }).get().join(""));

    $el.data("suffix", $el.find(".right-addon").map(function (i, e) {
      return $(e).text();
    }).get().join(""));
  },
  getValue: function getValue(el) {
    var $el = $(el);

    var text = $el.find("input[type=\"text\"]").val();

    if (text === "") {
      return null;
    }

    var left = $el.find(".left-group .dull-dropdown-input[id]").data("value") || "";
    var right = $el.find(".right-group .dull-dropdown-input[id]").data("value") || "";

    return left + $el.data("prefix") + text + $el.data("suffix") + right;
  },
  getState: function getState(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    var $el = $(el);
    if ($el.find("button").length) {
      $el.on("click.groupInputBinding", ".dull-button-input[id]", function (e) {
        callback();
      });
      $el.on("click.groupInputBinding", ".dull-dropdown-input[id] .dropdown-item", function (e) {
        callback();
      });
    } else {
      $el.on("change.groupInputBinding", function (e) {
        callback();
      });
    }
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".groupInputBinding");
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");

$(document).ready(function () {
  $(".dull-list-group-input[id]").on("click", ".list-group-item:not(.disabled)", function (e) {
    e.preventDefault();

    var $this = $(this);
    $this.toggleClass("active");
    $this.trigger("change");
  });
});

var listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-list-group-input[id]");
  },
  getValue: function getValue(el) {
    var $val = $(el).children(".list-group-item.active:not(:disabled)").map(function (i, e) {
      return $(e).data("value");
    }).get();
    return $val === undefined ? null : $val;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.listGroupInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".listGroupInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.items !== undefined) {
      $el.find(".list-group-item").remove();
      if ($el.children().length !== 0) {
        $el.children().first().before(data.items);
      } else {
        $el.html(data.items);
      }
    }

    if (data.state !== undefined) {
      var state = data.state === "valid" ? null : "list-group-item-" + data.state;

      if (data.filter !== null) {
        $.each(data.filter, function (i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]").attr("class", function (i, c) {
            return c.replace(/list-group-item-(success|info|warning|danger)/g, "");
          }).addClass(state);
        });
      } else {
        $el.find(".list-group-item").attr("class", function (i, c) {
          return c.replace(/list-group-item-(success|info|warning|danger)/g, "");
        }).addClass(state);
      }
    }

    if (data.disable) {
      if (data.disable === true) {
        $el.find(".list-group-item").each(function (i, e) {
          $(e).prop("disabled", true);
        });
      } else {
        $.each(data.disable, function (i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]").prop("disabled", true);
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find(".list-group-item").each(function (i, e) {
          $(e).prop("disabled", false);
        });
      } else {
        $.each(data.enable, function (i, v) {
          $el.find(".list-group-item[data-value=\"" + v + "\"]").prop("disabled", false);
        });
      }
    }

    if (data.increment) {
      if (data.increment === true) {
        var $badge = $el.find(".list-group-item .badge");

        if ($badge.length !== 0) {
          $badge.each(function (i, e) {
            $(e).text(parseInt($(e).text(), 10) + 1);
          });
        }
      } else {
        $.each(data.increment, function (i, v) {
          var $badge = $el.find(".list-group-item[data-value=\"" + v + "\"] .badge");

          if ($badge.length !== 0) {
            $badge.text(parseInt($badge.text(), 10) + 1);
          }
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");

var loginInputBinding = new Shiny.InputBinding();

$.extend(loginInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-login-input[id]");
  },
  getValue: function getValue(el) {
    var values = $(el).find(".form-control").map(function (i, e) {
      return $(e).val();
    }).get();

    if (!values[0] && !values[1]) {
      return null;
    }

    return {
      username: values[0],
      password: values[1]
    };
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.loginInputBinding", ".btn", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".loginInputBinding");
  }
});

Shiny.inputBindings.register(loginInputBinding, "dull.loginInput");

var radioInputBinding = new Shiny.InputBinding();

$.extend(radioInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-radio-input[id]");
  },
  getValue: function getValue(el) {
    var $val = $(el).find("input[type=\"radio\"]:checked:not(:disabled)").data("value");
    return $val === undefined ? null : $val;
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.radioInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".radioInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.choices !== undefined) {
      $el.find(".custom-radio").remove();
      $el.find(".form-control-feedback").before(data.choices);
    }

    if (data.state) {
      $el.attr("class", function (i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      $el.find(".form-control-feedback").empty();

      if (data.state !== "valid") {
        $el.addClass("has-" + data.state);

        if (data.hint) {
          $el.find(".form-control-feedback").html(data.hint);
        }
      }
    }

    if (data.disable) {
      if (data.disable === true) {
        $el.find("input[type=\"radio\"]").each(function (i, e) {
          $(e).prop("disabled", true);
        });
      } else {
        $.each(data.disable, function (i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]").prop("disabled", true);
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find("input[type=\"radio\"]").each(function (i, e) {
          $(e).prop("disabled", false);
        });
      } else {
        $.each(data.enable, function (i, v) {
          $el.find("input[type=\"radio\"][data-value=\"" + v + "\"]").prop("disabled", false);
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(radioInputBinding, "dull.radioInput");

var radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-radiobar-input[id]");
  },
  getValue: function getValue(el) {
    return $(el).find("input[type=radio]:checked").data("value");
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.radiobarInputBinding", function (e) {
      callback();
    });
    $(el).on("change.radiobarInputBinding", function (e) {
      callback();
    });
  },
  unsubcribe: function unsubcribe(el) {
    $(el).off(".radiobarInputBinding");
  }
});

Shiny.inputBindings.register(radiobarInputBinding, "radiobarInput");

var selectInputBinding = new Shiny.InputBinding();

$.extend(selectInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-select-input[id]");
  },
  getValue: function getValue(el) {
    return $(el).find("option:checked").map(function (i, e) {
      var $val = $(e).data("value");
      return $val === undefined ? null : $val;
    }).get();
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.selectInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".selectInputBinding");
  }
});

Shiny.inputBindings.register(selectInputBinding, "dull.selectInput");

var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  getType: function getType(el) {
    return "dull.table.input";
  },
  getValue: function getValue(el) {
    var $el = $(el);

    var columns = $el.find("thead th").map(function (i, e) {
      return $(e).text();
    }).get();

    var value = $el.find("tr").filter(function (i, e) {
      return $(e).data("selected");
    }).map(function (i, row) {
      var obj = {};

      $(row).children("td").each(function (j, cell) {
        obj[columns[j + 1]] = $(cell).text();
      });

      return obj;
    }).get();

    return JSON.stringify(value);
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.tableInputBinding", function (e) {
      callback();
    });
    $(el).on("click.tableInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".tableInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.validate) {
      $.each(data.validate, function (i, index) {
        $el.find("tbody tr:nth-child(" + index + ")").addClass("table-" + data.state);
      });
    }
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

$(document).ready(function () {
  $(".dull-table-thruput[id]").on("click", "tbody tr", function (e) {
    var $this = $(this);

    if ($this.data("selected")) {
      $this.data("selected", false).attr("class", function (i, c) {
        c = c || "";
        var d = c.replace(/bg-(primary|success|info|warning|danger)/g, "table-$1").replace(/table-dark/g, "");

        return d;
      });
    } else {
      $this.data("selected", true).attr("class", function (i, c) {
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
  find: function find(scope) {
    return $(scope).find(".dull-textual-input[id]");
  },
  getValue: function getValue(el) {
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
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function getRatePolicy() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.textualInputBinding", function (e) {
      callback(true);
    });
    $(el).on("input.textualInputBinding", function (e) {
      callback(true);
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".textualInputBinding");
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");

Shiny.addCustomMessageHandler("dull:modal", function (msg) {
  if (msg.close === true) {
    $(".modal").modal("hide");
    return true;
  }

  if ($(".modal").length) {
    modal = $(".modal");
  } else {
    var modal = $("<div>", {
      "class": "modal fade",
      "tabindex": -1,
      "role": "dialog"
    }).append($("<div>", {
      "class": "modal-dialog",
      "role": "document"
    }).append($("<div>", {
      "class": "modal-content"
    }).append($("<div>", {
      "class": "modal-header"
    }).append($("<h5>", { "class": "modal-title" }), $("<button>", {
      "type": "button",
      "class": "close",
      "data-dismiss": "modal",
      "aria-label": "Close"
    }).append($("span", {
      "class": "fa fa-times-rectangle"
    }))), $("<div>", {
      "class": "container-fluid"
    }).append($("<div>", { "class": "modal-body" })))));

    $("<body>").append(modal);
  }

  $(".modal-title").html(msg.title);
  $(".modal-body").html(msg.body);

  if (msg.footer) {
    if (!$(".modal-footer").length) {
      $(".modal-content").append($("<div>", {
        "class": "modal-footer"
      }).html(msg.footer));
    } else {
      $(".modal-content").html(msg.footer);
    }
  }
});

$(document).ready(function () {
  $(document).on("shown.bs.modal", ".modal", function (e) {
    console.log($(".modal").find(".shiny-bound-output, .shiny-bound-input").length);
    if (!$(".modal").find(".shiny-bound-output, .shiny-bound-input").length) {
      console.log("no bound found");
      Shiny.initializeInputs(".modal");
      Shiny.bindAll(".modal");
    }
  });
});

var badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-badge-output[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);

    if (data.value !== null && data.value !== undefined) {
      $el.text(data.value);
    }

    if (data.context) {
      var context = "badge-" + data.context;

      if (!$el.hasClass(context)) {
        $el.attr("class", function (i, c) {
          return c.replace(/badge-(default|primary|success|info|warning|danger)/g, "");
        });
        $el.addClass(context);
      }
    }
  },
  renderError: function renderError(el, data) {},
  clearError: function clearError(el) {}
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");

$.extend(Shiny.progressHandlers, {
  "dull-progress": function dullProgress(msg) {
    console.log(msg);

    var $bar = $(".dull-progress-output #" + msg.id);

    $bar.attr("style", function (i, s) {
      return s.replace(/width: [0-9]+%/, "width: " + msg.value + "%");
    }).attr("aria-valuenow", msg.value);

    if (msg.label) {
      $bar.text(msg.label);
    }

    if (msg.context) {
      $bar.attr("class", function (i, c) {
        return c.replace(/bg-(?:primary|secondary|success|info|warning|danger|light|dark|white)/g, "bg-" + msg.context);
      });
    }
  }
});

var radialOutputBinding = new Shiny.OutputBinding();

$.extend(radialOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-radial-output[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var dat = [30, 86, 168, 281, 303, 365];

    d3.select(".chart").selectAll("div").data(dat).enter().append("div").style("width", function (d) {
      return d + "px";
    }).text(function (d) {
      return d;
    });
  }
});

Shiny.outputBindings.register(radialOutputBinding, "dull.radialOutput");

var sparklineOutputBinding = new Shiny.OutputBinding();

$.extend(sparklineOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-sparkline-output[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    if (data.values) {
      var $el = $(el);

      var labels = $el.data("labels");

      $el.text(function (i, c) {
        var contents = "{" + data.values.join(",") + "}";

        if (labels) {
          contents = data.raw[0] + contents + data.raw[data.raw.length - 1];
        }

        if (c === "") {
          return contents;
        } else {
          return c.replace(/{[0-9,]*}/, contents);
        }
      });
    }
  },
  renderError: function renderError(el, data) {},
  clearError: function clearError(el) {}
});

Shiny.outputBindings.register(sparklineOutputBinding, "dull.sparklineOutput");

$.extend(Shiny.progressHandlers, {
  "dull-stream": function dullStream(data) {
    $("<li>").addClass("list-group-item").addClass(data.context ? "list-group-item-" + data.context : "").text(data.message).hide().appendTo($("#" + data.id)).fadeIn(300);

    return false;
  }
});

var tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);
    var context = $el.data("table");

    if (data.data && data.columns) {
      $el.empty();

      $el.append($("<thead>").append($("<tr>", {
        "class": context
      }).append($("<th>").text("#"), $.map(data.columns, function (col, i) {
        return $("<th>").addClass("thead-default").text(col);
      }))), $("<tbody>").append($.map(data.data, function (row, i) {
        var heading;
        if ("_row" in row) {
          heading = $("<th>").text(row._row).attr("scope", "row");
          delete row._row;
        } else {
          heading = $("<th>").text(i + 1).attr("scope", "row");
        }

        return $("<tr>", {
          "color": context
        }).append(heading, $.map(Object.entries(row), function (_ref, i) {
          var _ref2 = _slicedToArray(_ref, 2),
              key = _ref2[0],
              value = _ref2[1];

          return $("<td>").text(value).data("col", key);
        }));
      })));
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");

/**
 * WORK IN PROGRESS
 */

var tooltipBinding = new Shiny.OutputBinding();

$.extend(tooltipBinding, {
  find: function find(scope) {
    return null;
  },
  getId: function getId(el) {
    return null;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);

    if (data.remove) {
      $el.removeAttr("data-toggle");
      $el.removeAttr("data-placement");
      $el.removeAttr("title");

      return false;
    }

    if (data.show) {}
  }
});

//Shiny.outputBindings.register(tooltipBinding, "dull.tooltip");