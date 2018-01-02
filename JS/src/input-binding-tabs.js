var tabsInputBinding = new Shiny.InputBinding();

$.extend(tabsInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-tabs[id]");
  },
  getValue: function(el) {
    return $(".nav", el).find(".active").data("value");
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("shown.bs.tab.tabsInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tabsInputBinding");
  }
});

Shiny.inputBindings.register(tabsInputBinding, "dull.tabsInput");
