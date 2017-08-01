var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function(scope){
    return $(scope).find(".dull-checkbox-input[id]");
  },
  getValue: function(el) {
    var $val = $(el)
      .find("input[type=\"checkbox\"]:checked:not(:disabled)")
      .data("value");
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
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".checkboxInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.value !== undefined) {
      $el.data("value", data.value);
    }

    if (data.state !== undefined) {
      $el.attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/g, "");
      });

      if (data.context) {
        $el.addClass("has-" + data.state);
      }
    }

    if (data.disable === true) {
      $el.find("input[type=\"checkbox\"]").prop("disabled", true);
    }

    if (data.enable === true) {
      $el.find("input[type=\"checkbox\"]").prop("disabled", false);
    }

    if (data.remove === true) {
      $el.remove();
    }

    $el.trigger("change");
  }
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");
