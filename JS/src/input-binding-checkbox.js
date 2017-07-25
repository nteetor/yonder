var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function(scope){
    return $(scope).find(".dull-checkbox-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .find("input[type=\"checkbox\"]:checked:not(:disabled)")
      .map(function(i, e) {
        return $(e).data("value");
      })
      .get();
    return $val === undefined ? null : $val;
  },
  _getLabel: function(el) {
    return $(el).find(".custom-control-description").text();
  },
  getState: function(el, data) {
    return {
      label: this._getLabel(el),
      value: this.getValue(el)
    };
  },
  subscribe: function(el, callback) {
    $(el).on("change.checkboxInputBinding", function(e) {
      callback(true);
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.context) {
      $el.attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      if (data.context !== "none") {
        $el.addClass("has-" + data.context);
      }
    }

    if (data.disable !== null) {
      $el.find("input[type=\"checkbox\"]").each(function(i, e) {
        $(e).prop("disabled", data.disable);
      });
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");
