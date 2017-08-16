var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getType: function(el) {
    return "dull.table.input";
  },
  getValue: function(el) {
    var $el = $(el);
    var value = $el.find(".data-row")
      .map(function(i, e) {
        var obj = {};
        $(e).find(".dull-selected-cell").each(function(j, f) {
          obj[$(f).data("col")] = $(f).text();
        });
        return obj;
      })
      .get();
    return JSON.stringify(value);
  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.tableInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tableInputBinding");
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

$(document).ready(function() {
  $(".dull-table-thruput[id]").on("click", ".table-toggle", function(e) {
    var $this = $(this);
    var $table = $this.closest(".dull-table-thruput[id]");

    $table.find(".data-cell")
      .addClass("dull-selected-cell table-" + $table.data("context"));
    $this.trigger("change");
  });
  $(".dull-table-thruput[id]").on("click", ".row-selector", function(e) {
    var $this = $(this).closest("td");
    var context = $this.closest(".dull-table-thruput[id]").data("context");
    $this.siblings(".data-cell").addClass("dull-selected-cell")
      .addClass("table-" + context);
    $this.trigger("change");
  });
    $(".dull-table-thruput[id]").on("click", ".row-deselector", function(e) {
    var $this = $(this).closest("td");
    var context = $this.closest(".dull-table-thruput[id]").data("context");
    $this.siblings(".data-cell").removeClass("dull-selected-cell")
      .removeClass("table-" + context);
    $this.trigger("change");
  });
  $(".dull-table-thruput[id]").on("click", ".column-selector", function() {
    var $this = $(this).closest("td");
    var $table = $this.closest(".dull-table-thruput[id]");
    var column = $this.index() + 1;
    var context = $table.data("context");
    $table.find(".data-cell:nth-child(" + column + ")")
      .addClass("table-" + context)
      .addClass("dull-selected-cell");
    $this.trigger("change");
  });
  $(".dull-table-thruput[id]").on("click", ".column-deselector", function() {
    var $this = $(this).closest("td");
    var $table = $this.closest(".dull-table-thruput[id]");
    var column = $this.index() + 1;
    var context = $table.data("context");
    $table.find(".data-cell:nth-child(" + column + ")")
      .removeClass("table-" + context)
      .removeClass("dull-selected-cell");
    $this.trigger("change");
  });
});
