var formInputBinding = new Shiny.InputBinding();

$.extend(formInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-form[id]");
  },
  getValue: function(el) {
    var $inputs = $(el).find(".dull-input[id]");

    console.log($inputs);

    if (!$inputs.length) {
      return null;
    }

    return $inputs
      .map((i, e) => {
        var ids = $(e)
          .parentsUntil(".dull-form", "[id]")
          .map((j, a) => a.id)
          .get();

        ids.push(e.id);
        ids.reverse();

        return ids.reduce((acc, obj) => ({ [obj]: acc }), $(e).val() || null);
      })
      .get()
      .reduce((acc, obj) => {
        let key = Object.keys(obj);

        if (!acc.hasOwnProperty(key)) {
          return Object.assign(acc, obj);
        } else {
          return Object.assign(acc, { [key]: Object.assign(acc[key], obj[key]) });
        }
      }, {});
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("dull:formchange.formInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".formInputBinding");
  }
});

Shiny.inputBindings.register(formInputBinding, "dull.formInput");
