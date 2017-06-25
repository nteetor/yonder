$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});

$(function () {
  $('[data-toggle="popover"]').popover();
});

var alertInputBinding = new Shiny.InputBinding();

$.extend(alertInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-alert[id] .close").parent();
  },
  getValue: function(el) {
    var ret = $(el).data("closed") || null;
    console.log(ret);
    return ret;
  },
  getState: function(el) {
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

var buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-button[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    var $textual = $el.find("input");
    var textValue = null;

    if ($textual.length && $textual.val().length) {
      textValue = $textual.val();
    }

    return {
      count: parseInt($el.data("count"), 10),
      value: textValue
    };
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  getType: function(el) {
    return "dull.button";
  },
  subscribe: function(el, callback) {
    $(el).on("click.buttonInputBinding", function(e) {
      var $el = $(el);
      $el.data("count", parseInt($el.data("count")) + 1);

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
    var $button = $el.find("button");

    if (data.count !== null) {
      $el.data("count", data.count);
    }

    if (data.context) {
      $button.attr("class", function(i, c) {
        return c.replace(/btn-(?:outline-)?(?:primary|secondary|link|success|info|warning|danger)/, "");
      });
      $button.addClass(data.context);
    }

    if (data.count !== null || data.context) {
      $el.trigger("change");
    }
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");

$(document).ready(function() {
  $(".dull-button input").click(function(e) {
    e.stopPropagation();
  });
});

var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function(scope){
    return $(scope).find(".dull-checkbox[id]");
  },
  getValue: function(el) {
    return $(el).find('input[type="checkbox"]:checked').val() || null;
  },
  _getLabel: function(el) {
    return $(el).find(".custom-control-description").text();
  },
  getState: function(el) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.checkboxInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxInputBinding");
  }
/*  receiveMessage: function(el, data) {
    if (data.hasOwnProperty("context")) {
      $(el).attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/, data.context);
      });
    }

    $(el).trigger("change");
  } */
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");

$(document).ready(function() {
  $(".dull-dropdown[id] a").click(function(e) {
    e.preventDefault();

    var el  = $(e.target);
    var p = el.parent().parent();

    p.data("value", el.attr("href") || 0);

    p.trigger("child:click");
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown[id]");
  },
  getValue: function(el) {
    return $(el).data("value");
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("child:click.dropdownInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");

$(document).ready(function() {
  $(".dull-list-group[id] .list-group-item:not(.disabled)").click(function(e) {
    e.preventDefault();

    var el = $(e.target);
    el.toggleClass("active");

    el.parent().trigger("change");
  });
});

var listGroupBinding = new Shiny.InputBinding();

$.extend(listGroupBinding, {
  find: function(scope) {
    return $(scope).find(".dull-list-group[id]");
  },
  getValue: function(el) {
    return $(el)
      .children(".list-group-item.active")
      .map(function() {
        return $(this).data("value");
      })
      .get();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.listGroupBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".listGroupBinding");
  }
});

Shiny.inputBindings.register(listGroupBinding, "dull.listGroup");

var listGroupItemBinding = new Shiny.InputBinding();

$.extend(listGroupItemBinding, {
  find: function(scope) {
    return $(scope).find(".dull-list-group-item[id]");
  },
  getValue: function(el) {
    return $(el).data("value");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.label) {
      $el.text(data.label);
    }

    if (data.value) {
      $el.data("value", data.value);
    }

    if (data.context) {
      $el.attr("class", function(i, c) {
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
  find: function(scope) {
    return $(scope).find(".dull-radios[id]");
  },
  getValue: function(el) {
    return $(document).find(".dull-radios input:radio:checked").val();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.radiosInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".radiosInputBinding");
  }
});

Shiny.inputBindings.register(radiosInputBinding, "dull.radiosInput");

var textInputBinding = new Shiny.InputBinding();

$.extend(textInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-text[id]");
  },
  getValue: function(el) {
    return $(el).val();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  getRatePolicy: function() {
    return {
      policy: "debounce",
      delay: 250
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  }
});

Shiny.inputBindings.register(textInputBinding, "dull.textInput");

var textualInputBinding = new Shiny.InputBinding();

$.extend(textualInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-textual[id]");
  },
  getValue: function(el) {
    return $el.find("input").val();
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.textualInputBinding", function(e) {
      callback(false);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".textualInputBinding");
  },
  getRatePolicy: function() {
    return {
      policy: 'debounce',
      delay: 250
    };
  }
});

Shiny.inputBindings.register(textualInputBinding, "dull.textualInput");

Shiny.addCustomMessageHandler("dull.modal.toggle", function(msg) {
  var $modal = $(msg.id);

  if ($modal.length === 0) {
    return false;
  }

  $modal.modal("toggle");
});

var alertOutputBinding = new Shiny.OutputBinding();

$.extend(alertOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-alert[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
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
  find: function(scope) {
    return $(scope).find(".dull-badge[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
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
  _removeContextClasses: function(el) {
    var $el = $(el);
    $el.attr("class", function(i, c) {
      return c.replace(
        /badge-(default|primary|success|info|warning|danger)/g,
        ""
      );
    });
  }
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");

var barOutputBinding = new Shiny.OutputBinding();

$.extend(barOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-bar[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
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
  dull: function(data) {
    console.log(data.template);

    $(data.template)
      .text(data.content)
      .hide()
      .appendTo($(data.id))
      .fadeIn(300);

    return false;
  }
});
