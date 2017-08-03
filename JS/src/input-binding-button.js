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

    return {
      clicks: parseInt($el.data("clicks"), 10),
      value: $el.data("value") || null
    };
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

    if (data.clicks !== null) {
      $el.data("clicks", data.clicks);
    }

    if (data.context) {
      $el.attr("class", function(i, c) {
        return c.replace(/btn-(?:outline-)?(?:primary|secondary|link|success|info|warning|danger)/, "");
      })
      .addClass("btn-" + data.context);
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(buttonInputBinding, "dull.buttonInput");
