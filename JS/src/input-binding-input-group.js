var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-input-group[id]");
  },
  getValue: function(el) {
    var $el = $(el);

    var text = $el.find("input[type=\"text\"]").val() || "";

    if (!text) {
      return null;
    }

    var left = $el.find(".input-group-addon:first-child").text();
    var right = $el.find(".input-group-addon:last-child").text();

    return {
      value: left + text + right,
      click: $el.data("value") || null
    };
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var $el = $(el);
    if ($el.find("button").length) {
      $el.on("dull:click.groupInputBinding", function(e, data) {
        if (data.value !== null) {
          $el.data("value", data.value);
        }
        callback();
      });
    } else {
      $el.on("dull:textchange.groupInputBinding", function(e) {
        callback();
      });
    }
  },
  unsubscribe: function(el) {
    $(el).off(".groupInputBinding");
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");

$(document).ready(function() {
  $(".dull-input-group[id] input[type=\"text\"]").on("change", function(e) {
    e.preventDefault();
    $(this).trigger("dull:textchange");
  });
  $(".dull-input-group[id] button:not(.dropdown-toggle)")
    .on("click", function(e) {
      e.preventDefault();
      var $this = $(this);
      $this.trigger("dull:click", { value: $this.data("value") || null });
    });
  $(".dull-input-group[id] .dull-dropdown-item").on("click", function(e) {
    e.preventDefault();
    var $this = $(this);
    $this.trigger("dull:click", { value: $this.data("value") || null });
  });
});
