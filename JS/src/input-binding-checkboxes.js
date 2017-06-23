var checkboxInputBinding = new Shiny.InputBinding();

$.extend(checkboxInputBinding, {
  find: function(scope){
    return $(scope).find(".dull-checkbox[id]");
  },
  getValue: function(el) {
    return $(el).find('input[type="checkbox"]:checked').val() || null;
  },
  _getLabel: function(el) {
    return $(el).find(".custom-control-description").text();
  },
  getState: function(el) {
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
  }
/*  receiveMessage: function(el, data) {
    if (data.hasOwnProperty("context")) {
      $(el).attr("class", function(i, c) {
        return c.replace(/has-(success|warning|danger)/, data.context);
      });
    }

    $(el).trigger("change");
  } */
});

Shiny.inputBindings.register(checkboxInputBinding, "dull.checkboxInput");
