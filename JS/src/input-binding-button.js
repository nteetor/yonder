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
