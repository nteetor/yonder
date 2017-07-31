$(document).ready(function() {
  $(".dull-list-group-input[id] .list-group-item:not(.disabled)").click(function(e) {
    e.preventDefault();

    var $this = $(this);
    $this.toggleClass("active");
    $this.trigger("dull:change");
  });
});

var listGroupInputBinding = new Shiny.InputBinding();

$.extend(listGroupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-list-group-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .children(".list-group-item.active:not(:disabled)")
      .map(function(i, e) {
        return $(e).data("value");
      })
      .get();
    return $val === undefined ? null : $val;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("dull:change.listGroupInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".listGroupInputBinding");
  }
});

Shiny.inputBindings.register(listGroupInputBinding, "dull.listGroupInput");

var listGroupItemBinding = new Shiny.InputBinding();

$.extend(listGroupItemBinding, {
  find: function(scope) {
    return $(scope).find(".dull-list-group-item[id]");
  },
  getValue: function(el) {
    return null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.context) {
      $el.attr("class", function(i, c) {
        return c.replace(/list-group-item-(success|info|warning|danger)/, "");
      });
      if (data.context !== "none") {
        $el.addClass("list-group-item-" + data.context);
      }
    }

    if (data.active) {
      $el.prop("active", data.active);
    }

    if (data.disabled) {
      $el.prop("disabled", data.disabled);
    }

    $el.trigger("dull:change");
  }
});

Shiny.inputBindings.register(listGroupItemBinding, "dull.listGroupItem");
