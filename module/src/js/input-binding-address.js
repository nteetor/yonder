export const addressInputBinding = new Shiny.InputBinding();

$.extend(addressInputBinding, {
  find: function(scope) {
    return $(scope).find(".yonder-address[id]");
  },
  getValue: function(el) {
    var $el = $(el);
    var $inputs = $el.find("input");
    var names = ["line1", "line2", "city", "state", "zip"];

    var values = $inputs.map((i, e) => $(e).val())
      .get()
      .reduce(function(acc, val, i) {
        acc[names[i]] = val;
        return acc;
      }, {});

    if (!Object.values(values).reduce((acc, obj) => acc || obj)) {
      return null;
    }

    return values;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.addressInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".addressInputBinding");
  }
});

Shiny.inputBindings.register(addressInputBinding, "yonder.addressInput");
