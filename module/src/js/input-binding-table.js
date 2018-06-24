var tableInputBinding = new Shiny.InputBinding();

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

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");
