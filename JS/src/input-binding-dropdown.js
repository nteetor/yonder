$(document).ready(function() {
  $(".dull-dropdown-input").on("click", ".dropdown-item:not(.disabled)", function(e) {
    var $this = $(this);

    $this.trigger("click", {
      value: $this.data("value") === undefined ? null : $this.data("value")
    });
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown-input[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    return $el.data("value") === undefined ? null : $el.data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.dropdownInputBinding", function(e, data) {
      $(el).data("value", data.value);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");
