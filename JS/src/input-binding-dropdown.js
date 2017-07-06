$(document).ready(function() {
  $(".dull-dropdown[id] a").click(function(e) {
    e.preventDefault();

    var el  = $(e.target);
    var p = el.parents(".dull-dropdown[id]").first();

    p.data("value", el.data("value") || null);

    p.trigger("child:click");
  });
});

var dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-dropdown[id]");
  },
  getValue: function(el) {
    return $(el).data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("child:click.dropdownInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".dropdownInputBinding");
  }
});

Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");
