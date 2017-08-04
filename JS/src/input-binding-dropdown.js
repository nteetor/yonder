$(document).ready(function() {
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item", function(e) {
    e.preventDefault();
  });
  $(".dull-dropdown-input[id]").on("click", ".dropdown-item:not(.disabled)", function(e) {
    $(this).trigger("click:item", {
      value: $(this).data("value")
    });
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown-input[id]");
  },
  getValue: function(el) {
    var $value = $(el).data("value");

    return $value === undefined ? null : $value;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click:item.dropdownInputBinding", function(e, data) {
      $(el).data("value", data.value);
      callback();
    });
    $(el).on("change.dropdownInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.disable) {
      if (data.disable === true) {
        $el.find(".dropdown-toggle").prop("disabled", true);
        $el.data("value", null);
      } else {
        $.each(data.disable, function(i, v) {
          var $item = $el.find(".dropdown-item[data-value=\"" + v + "\"]");

          if ($item.length !== 0 && !$item.hasClass("disabled")) {
            $item.addClass("disabled");
          }

          if (v == $el.data("value")) {
            $el.data("value", null);
          }
        });
      }
    }

    if (data.enable) {
      if (data.enable === true) {
        $el.find(".dropdown-toggle").prop("disabled", false);
        $el.find(".dropdown-item").removeClass("disabled");
      } else {
        $.each(data.enable, function(i, v) {
          var $item = $el.find(".dropdown-item[data-value=\"" + v + "\"]");
          if ($item.length !== 0) {
            $item.removeClass("disabled");
          }
        });
      }
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");
