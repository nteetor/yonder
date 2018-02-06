var alertInputBinding = new Shiny.InputBinding();

$.extend(alertInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-alert[id] .close").parent();
  },
  getValue: function(el) {
    var ret = $(el).data("closed") || null;
    return ret;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("closed.bs.alert.alertInputBinding", function(e) {
      $(el).data("closed", true);
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".alertInputBinding");
  }
});

Shiny.inputBindings.register(alertInputBinding, "dull.alertInput");
