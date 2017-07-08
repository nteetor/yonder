var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown[id]");
  },
  getValue: function(el) {
    return $(el).data("value") || null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("dull:itemclick.dropdownInputBinding", function(e, data) {
      $(el).data("value", data.value);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");

$(document).ready(function() {
  $(".dull-dropdown-item").on("click", function(e) {
    e.preventDefault();
    var $this = $(this);
    $this.trigger("dull:itemclick", {
      value: $this.data("value") || null
    });
  });
});