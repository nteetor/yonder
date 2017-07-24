var buttonInputBinding = new Shiny.InputBinding();

$.extend(buttonInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-button[id]");
  },
  getValue: function(el) {
    var $el = $(el);

    if ($el.data("count") === 0) {
      return null;
    }

    return {
      count: parseInt($el.data("count"), 10),
      value: $el.data("value") || null
    };
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.buttonInputBinding", function(e) {
      var $el = $(el);
      $el.data("count", parseInt($el.data("count"), 10) + 1);

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

    if (data.count !== null) {
      $el.data("count", data.count);
    }

    if (data.context) {
      $el.attr("class", function(i, c) {
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
  find: function(scope) {
    return $(scope).find(".dull-button-group[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    return {
      count: $el.data("count") || null,
      value: $el.data("value") || null
    };
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.buttonGroupInputBinding", function(e) {
      callback();
    });
    $(el).on("change.buttonGroupInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".buttonGroupInputBinding");
  }
});

Shiny.inputBindings.register(buttonGroupInputBinding, "dull.buttonGroupInput");

$(document).ready(function() {
  $(".dull-button-group[id] button").on("click", function(e) {
    var $child = $(this);
    var $parent = $child.parent(".dull-button-group");

    $parent
      .data("value", $child.data("value"))
      .data("count", parseInt($parent.data("count"), 10) + 1)
      .trigger("change");
  });
});
