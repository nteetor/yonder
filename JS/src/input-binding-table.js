var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table[id]");
  },
  getValue: function(el) {
    var arr = $(el).find('thead tr,.dull-row').get().map(function(row) {
      return $(row).find('th:not([scope]),td').get().map(function(cell) {
        return $(cell).html();
      });
    });

    return arr.reduce(function(acc, obj, i) {
      acc[i] = obj;
      return acc;
    }, {});
  },
  getType: function(el) {
    return "dull.table";
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("click.tableInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tableInputBinding");
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");
