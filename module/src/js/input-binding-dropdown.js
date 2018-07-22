export let dropdownInputBinding = new Shiny.InputBinding();

$.extend(dropdownInputBinding, {
  Selector: {
    SELF: ".dull-dropdown-input",
    LABEL: ".dropdown-item",
    VALUE: ".dropdown-item"
  },
  getValue: function(el) {
    return null;
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {

  },
  unsubscribe: function(el) {

  },
  receiveMessage: function(el) {
    console.error("receiveMessage: not implemented for dropdown input");
    return;
  }
});

// Shiny.inputBindings.register(dropdownInputBinding, "dull.dropdownInput");
