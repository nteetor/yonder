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
  getState: function(el, data) {
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
