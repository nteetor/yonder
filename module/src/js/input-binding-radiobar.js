export let radiobarInputBinding = new Shiny.InputBinding();

$.extend(radiobarInputBinding, {
  Selector: {
    SELF: ".yonder-radiobar[id]",
    VALUE: ".btn input",
    LABEL: ".btn > span",
    SELECTED: ".btn input:checked"
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.radiobarInputBinding", function(e) {
      callback();
    });
    $(el).on("change.radiobarInputBinding", function(e) {
      callback();
    });
  },
  unsubcribe: function(el) {
    $(el).off(".radiobarInputBinding");
  }
});
