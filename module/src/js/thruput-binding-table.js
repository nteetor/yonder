export let tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  Selector: {
    SELF: ".yonder-table[id]"
  },
  Type: "yonder.table",
  Events: [
    { type: "chabudai:select" },
    { type: "chabudai:edited" }
  ],
  getValue: function(el) {
    return JSON.stringify($(el).table("selected"));
  },
  receiveMessage: function(el, msg) {
    return;
  }
});

export let tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function(scope) {
    return $(scope).find(".yonder-table[id]");
  },
  renderValue: function(el, msg) {
    if (msg.data) {
      $(el).table({ "data": msg.data });
    }
  }
});

Shiny.inputBindings.register(tableInputBinding, "yonder.tableInput");
Shiny.outputBindings.register(tableOutputBinding, "yonder.tableOutput");
