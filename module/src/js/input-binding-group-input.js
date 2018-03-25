var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  Selector: {
    SELF: ".dull-group-input",
    SELECTED: ".input-group-prepend .input-group-text, input, .input-group-append .input-group-text",
    // LABEL: ".dull-button-input,"
  },
  find: function(scope) {
    return $(scope).find(".dull-group-input[id]");
  },
  getType: function(el) {
    return "dull.group.input";
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var $el = $(el);
    if ($el.find("button").length) {
      $el.on("click.groupInputBinding", ".dull-button-input[id]", function(e) {
        callback();
      });
      $el.on("click.groupInputBinding", ".dull-dropdown-input[id] .dropdown-item", function(e) {
        callback();
      });
    } else {
      $el.on("change.groupInputBinding", function(e) {
        callback();
      });
    }
  },
  unsubscribe: function(el) {
    $(el).off(".groupInputBinding");
  },
  receiveMessage: function(el, msg) {
    console.error("receiveMessage: not implemented for group input");
    return;
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");
