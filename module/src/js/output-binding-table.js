var tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  renderValue: function(el, msg) {
    if (msg.data) {
      $(el).table({ "data": msg.data });
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");
