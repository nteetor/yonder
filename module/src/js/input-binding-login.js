export let loginInputBinding = new Shiny.InputBinding();

$.extend(loginInputBinding, {
  find: function(scope) {
    return $(scope).find(".yonder-login[id]");
  },
  getValue: function(el) {
    var values = $(el).find(".form-control").map((i, e) => $(e).val()).get();

    if (!values[0] && !values[1]) {
      return null;
    }

    return {
      username: values[0],
      password: values[1]
    };
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.loginInputBinding", ".btn", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".loginInputBinding");
  }
});
