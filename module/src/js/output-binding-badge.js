export let badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function(scope) {
    return $(scope).find(".yonder-badge[id]");
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
