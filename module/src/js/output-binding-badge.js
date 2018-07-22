export let badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-badge-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, msg) {
    if (msg.data !== undefined) {
      el.innerHTML = msg.data;
    }
  },
  renderError: function(el, data) {

  },
  clearError: function(el) {

  }
});

// Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");
