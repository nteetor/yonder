var groupInputBinding = new Shiny.InputBinding();

$.extend(groupInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-group-input[id]");
  },
  _getAddonText: function(el, selector) {
    return $(el).find(selector)
      .map(function() { return $(this).text() })
      .get()
      .reduce(function(acc, txt) {
        return acc + txt;
      }, "");
  },
  getValue: function(el) {
    var $el = $(el);

    var text = $el.find(".form-control[type=\"text\"]").val();

    var leftText =  this._getAddonText(el, ".input-group-addon:first-child, .input-group-addon ~ .input-group-addon");
    var right = this._getAddonText(el, ".input-group-addon:last-child");

    if (text === "") {
      return null;
    }

    return leftText + leftDrop + text + right;
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    var $el = $(el);
    if ($el.find("button").length) {
      $el.on("click.groupInputBinding", function(e, data) {
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
