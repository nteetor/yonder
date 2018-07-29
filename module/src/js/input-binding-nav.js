export let navInputBinding = new Shiny.InputBinding();

$.extend(navInputBinding, {
  find: function(scope) {
    return $(scope).find(".yonder-nav[id]");
  },
  getValue: function(el) {
    return $(".nav", el).find(".active").data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("shown.bs.tab.navInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".navInputBinding");
  }
});
