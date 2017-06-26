var radiosInputBinding = new Shiny.InputBinding();

$.extend(radiosInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-radios[id]");
  },
  getValue: function(el) {
    return $(document).find(".dull-radios input:radio:checked").val();
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.radiosInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".radiosInputBinding");
  }
});

Shiny.inputBindings.register(radiosInputBinding, "dull.radiosInput");
