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
