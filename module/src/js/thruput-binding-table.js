export let tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  Selector: {
    SELF: ".dull-table-thruput"
  },
  Type: "dull.table.input",
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

// Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

export let tableOutputBinding = new Shiny.OutputBinding();

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

// Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");
