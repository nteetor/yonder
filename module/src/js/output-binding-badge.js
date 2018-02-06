var badgeOutputBinding = new Shiny.OutputBinding();

$.extend(badgeOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-badge-output[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.value !== null && data.value !== undefined) {
      $el.text(data.value);
    }
  },
  renderError: function(el, data) {

  },
  clearError: function(el) {

  }
});

Shiny.outputBindings.register(badgeOutputBinding, "dull.badgeOutput");
