export var tooltipBinding = new Shiny.OutputBinding();

$.extend(tooltipBinding, {
  find: function(scope) {
    return null;
  },
  getId: function(el) {
    return null;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.remove) {
      $el.removeAttr("data-toggle");
      $el.removeAttr("data-placement");
      $el.removeAttr("title");

      return false;
    }

    if (data.show) {

    }

  }
});
