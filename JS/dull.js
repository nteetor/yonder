"use strict";

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

$(function () {
  $("[data-toggle=\"tooltip\"]").tooltip();
});

$(function () {
  $("[data-toggle=\"popover\"]").popover();
});

$(document).on("shiny:connected", function () {
  $(".dull-submit[data-type=\"submit\"]").attr("type", "submit");
});

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
    return $(scope).find(".dull-button[id]");
  },
  getValue: function getValue(el) {
    var $el = $(el);

    return {
      count: parseInt($el.data("count"), 10),
      value: $el.data("value")
    };
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  getType: function getType(el) {
    return "dull.button";
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.buttonInputBinding", function (e) {
      var $el = $(el);
      $el.data("count", parseInt($el.data("count"), 10) + 1);

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

    if (data.count !== null) {
      $el.data("count", data.count);
    }

    if (data.context) {
      $el.attr("class", function (i, c) {
        return c.replace(/btn-(?:outline-)?(?:primary|secondary|link|success|info|warning|danger)/, "");
      });
      $el.addClass(data.context);
    }

    if (data.count !== null || data.context) {
      $el.trigger("change");
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");

var buttonGroupInputBinding = new Shiny.InputBinding();

$.extend(buttonGroupInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-button-group[id]");
  },
  getValue: function getValue(el) {
    var $el = $(el);
    return {
      count: $el.data("count") || null,
      value: $el.data("value") || null
    };
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("click.buttonGroupInputBinding", function (e) {
      callback();
    });
    $(el).on("change.buttonGroupInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".buttonGroupInputBinding");
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "dull.buttonGroupInput");

$(document).ready(function () {
  $(".dull-button-group[id] button").on("click", function (e) {
    var $child = $(e.target);
    var $parent = $child.parent(".dull-button-group");

    $parent.data("value", $child.data("value")).data("count", parseInt($parent.data("count"), 10) + 1).trigger("change");
  });
});

var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-checkbox[id]");
  },
  getValue: function getValue(el) {
    return $(el).find("input[type=\"checkbox\"]:checked").val() || null;
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
      callback(true);
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".checkboxInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.context) {
      $el.attr("class", function (i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });
      $el.addClass(data.context);
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");

$(document).ready(function () {
  $(".dull-dropdown[id] a").click(function (e) {
    e.preventDefault();

    var el = $(e.target);
    var p = el.parents(".dull-dropdown[id]").first();

    p.data("value", el.data("value") || null);

    p.trigger("child:click");
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-dropdown[id]");
  },
  getValue: function getValue(el) {
    return $(el).data("value");
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("child:click.dropdownInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".dropdownInputBinding");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");

var formGroupInputBinding = new Shiny.InputBinding();

$.extend(formGroupInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-form-group[id]");
  },
  getValue: function getValue(el) {
    var $children = $(el).children(".dull-input[id]");

    if (!$children.length) {
      return null;
    }

    return $children.map(function (i, e) {
      return _defineProperty({}, e.id, $(e).val() || null);
    }).get().reduce(function (acc, obj) {
      return Object.assign(acc, obj);
    });
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("dull:formchange.formGroupInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".formGroupInputBinding");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.state) {
      $el.attr("class", function (i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });
      $el.addClass(data.state);
    }
  }
});

Shiny.inputBindings.register(formGroupInputBinding, "dull.formGroupInput");

$(document).on("shiny:inputchanged", function (e) {
  var $el = $(e.el);

  if ($el.parents(".dull-form[id]").length) {
    var $parent = $el.parents(".dull-form[id]").first();

    if (!$parent.find(".dull-submit[type=\"submit\"]").length) {
      e.preventDefault();

      $parent.trigger("dull:formchange");
    }
  } else if ($el.parents(".dull-form-group[id]").length) {
    e.preventDefault();

    $el.parents(".dull-form-group[id]").first().trigger("dull:formchange");
  }
});

var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-form[id]");
  },
  getValue: function getValue(el) {
    var $inputs = $(el).find(".dull-input[id]");

    if (!$inputs.length) {
      return null;
    }

    return $inputs.map(function (i, e) {
      var ids = $(e).parentsUntil(".dull-form", "[id]").map(function (j, a) {
        return a.id;
      }).get();

      ids.push(e.id);
      ids.reverse();

      return ids.reduce(function (acc, obj) {
        return _defineProperty({}, obj, acc);
      }, $(e).val() || null);
    }).get().reduce(function (acc, obj) {
      var key = Object.keys(obj);

      if (!acc.hasOwnProperty(key)) {
        return Object.assign(acc, obj);
      } else {
        return Object.assign(acc, _defineProperty({}, key, Object.assign(acc[key], obj[key])));
      }
    }, {});
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("dull:formchange.formInputBinding", function (e) {
      callback();
    });
    $(el).on("dull:formsubmit.formInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");

$(document).ready(function () {
  $(".dull-form[id]").on("submit", function (e) {
    e.preventDefault();
    $(e.target).trigger("dull:formsubmit");
  });
});

$(document).ready(function () {
  $(".dull-list-group[id] .list-group-item:not(.disabled)").click(function (e) {
    e.preventDefault();

    var el = $(e.target);
    el.toggleClass("active");

    el.parent().trigger("change");
  });
});

var listGroupBinding = new Shiny.InputBinding();

$.extend(listGroupBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-list-group[id]");
  },
  getValue: function getValue(el) {
    return $(el).children(".list-group-item.active").map(function () {
      return $(this).data("value");
    }).get();
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.listGroupBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".listGroupBinding");
  }
});

Shiny.inputBindings.register(listGroupBinding, "dull.listGroup");

var listGroupItemBinding = new Shiny.InputBinding();

$.extend(listGroupItemBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-list-group-item[id]");
  },
  getValue: function getValue(el) {
    return $(el).data("value");
  },
  receiveMessage: function receiveMessage(el, data) {
    var $el = $(el);

    if (data.label) {
      $el.text(data.label);
    }

    if (data.value) {
      $el.data("value", data.value);
    }

    if (data.context) {
      $el.attr("class", function (i, c) {
        return c.replace(/list-group-item-(success|info|warning|danger)/, "");
      });
      $el.addClass(data.context);
    }

    if (data.active) {
      $el.prop("active", data.active);
    }

    if (data.disabled) {
      $el.prop("disabled", data.disabled);
    }
  }
});

Shiny.inputBindings.register(listGroupItemBinding, "dull.listGroupItem");

var radiosInputBinding = new Shiny.InputBinding();

$.extend(radiosInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-radios[id]");
  },
  getValue: function getValue(el) {
    return $(document).find(".dull-radios input:radio:checked").val();
  },
  getState: function getState(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function subscribe(el, callback) {
    $(el).on("change.radiosInputBinding", function (e) {
      callback();
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".radiosInputBinding");
  }
});

Shiny.inputBindings.register(radiosInputBinding, "dull.radiosInput");

var textInputBinding = new Shiny.InputBinding();

$.extend(textInputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-text[id]");
  },
  getValue: function getValue(el) {
    return $(el).val() || null;
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
    $(el).on("change.textInputBinding", function (e) {
      callback(true);
    });
  },
  unsubscribe: function unsubscribe(el) {
    $(el).off(".textInputBinding");
  }
});

Shiny.inputBindings.register(textInputBinding, "dull.textInput");

Shiny.addCustomMessageHandler("dull.modal.toggle", function (msg) {
  var $modal = $(msg.id);

  if ($modal.length === 0) {
    return false;
  }

  $modal.modal("toggle");
});

var alertOutputBinding = new Shiny.OutputBinding();

$.extend(alertOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-alert[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);

    if (data.show) {
      $el.removeClass("invisible").show();
    } else if (data.show !== null) {
      $el.hide();
    }
  }
});

Shiny.outputBindings.register(alertOutputBinding, "dull.alertOutput");

var badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-badge[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);
    $el.text(data.value);

    if (data.context) {
      var conClass = "badge-" + data.context;

      if (!$el.hasClass(conClass)) {
        this._removeContextClasses(el);
        $el.addClass(conClass);
      }
    }

    return false;
  },
  /*  renderError: function(el, err) {
      var $el = $(el);
      this._removeContextClasses(el);
  
      $el.addClass("badge-danger");
      this.prevText = $el.text();
      $el.text("*");
  
      return false;
    },
    clearError: function(el) {
      var $el = $(el);
      $el.removeClass("badge-danger");
      $el.addClass("badge-default");
      $el.text(this.prevText);
      this.prevText = null;
  
      return false;
    },*/
  _removeContextClasses: function _removeContextClasses(el) {
    var $el = $(el);
    $el.attr("class", function (i, c) {
      return c.replace(/badge-(default|primary|success|info|warning|danger)/g, "");
    });
  }
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");

var barOutputBinding = new Shiny.OutputBinding();

$.extend(barOutputBinding, {
  find: function find(scope) {
    return $(scope).find(".dull-bar[id]");
  },
  getId: function getId(el) {
    return el.id;
  },
  renderValue: function renderValue(el, data) {
    var $el = $(el);

    if (data.value !== null) {
      $el.attr("style", "width: " + data.value + "%");
    }

    if (data.label !== null) {
      $el.text(data.label);
    }

    /*
    $.each(data, function(key, value) {
      console.log(key + ": " + value);
    });
    */
  }
});

Shiny.outputBindings.register(barOutputBinding, "dull.barOutput");

$.extend(Shiny.progressHandlers, {
  dull: function dull(data) {
    console.log(data.template);

    $(data.template).text(data.content).hide().appendTo($(data.id)).fadeIn(300);

    return false;
  }
});