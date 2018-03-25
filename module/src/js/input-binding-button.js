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
