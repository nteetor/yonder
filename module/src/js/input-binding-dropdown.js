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
  Selector: {
    SELF: ".dull-dropdown-input",
    LABEL: ".dropdown-item",
    VALUE: ".dropdown-item"
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
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");
