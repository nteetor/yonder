var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-group-input[id]");
  },
  initialize: function(el) {
    var $el = $(el);

    $el.data("prefix", $el.find(".left-addon")
      .map((i, e) => $(e).text())
      .get()
      .join("")
    );

    $el.data("suffix", $el.find(".right-addon")
      .map((i, e) => $(e).text())
      .get()
      .join("")
    );
  },
  getValue: function(el) {
    var $el = $(el);

    var text = $el.find("input[type=\"text\"]").val();

    if (text === "") {
      return null;
    }

    var left = $el.find(".left-group .dull-dropdown-input[id]").data("value") || "";
    var right = $el.find(".right-group .dull-dropdown-input[id]").data("value") || "";

    return left + $el.data("prefix") + text + $el.data("suffix") + right;
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
  }
});

Shiny.inputBindings.register(groupInputBinding, "dull.groupInput");
