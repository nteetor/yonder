var tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    if (data.content) {
      $(el).html(data.content);
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");

$(document).ready(function() {
  $(".dull-table").delegate("tbody tr", "click", function(e) {
    var $this = $(this);
    var context = $this.parents(".dull-table").first().data("context");
    $this.toggleClass("table-" + context);
    $this.toggleClass("dull-row");
  });
});
