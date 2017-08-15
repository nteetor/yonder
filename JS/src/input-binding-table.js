var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getValue: function(el) {
    return $(el).find(".dull-selected-cell").get();
//    return $(el).find("thead tr, .dull-selected-cell").get().map(function(row) {
//      return $(row).find("th:not([scope]),td").get().map(function(cell) {
//        return $(cell).html();
//      });
//    })
//      .reduce(function(acc, obj, i) {
//        acc[i] = obj;
//        return acc;
//      }, {});
  },
//  getType: function(el) {
//    return "dull.table";
//  },
  getState: function(el, data) {
    return { value: this.getValue(el) };
  },
  subscribe: function(el, callback) {
    $(el).on("change.tableInputBinding", function(e) {
      console.log("change?");
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tableInputBinding");
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

$(document).ready(function() {
  $(".dull-table-thruput[id]").on("click", ".row-selector", function(e) {
    var context = $(this).closest(".dull-table-thruput[id]").data("context");
    $(this).siblings("td").toggleClass("dull-selected-cell")
      .toggleClass("table-" + context);
    $(this).trigger("change");
  });
  $(".dull-table-thruput[id]").on("click", ".column-selector", function() {
    var $this = $(this).closest("th");
    var $table = $this.closest(".dull-table-thruput[id]");
    var column = $this.index() + 1;
    var context = $table.data("context");
    $table.find("tbody tr :nth-child(" + column + ")")
      .addClass("table-" + context)
      .addClass("dull-selected-cell")
      .trigger("change");
  });
  $(".dull-table-thruput[id]").on("click", ".column-deselector", function() {
    var $this = $(this).closest("th");
    var $table = $this.closest(".dull-table-thruput[id]");
    var column = $this.index() + 1;
    var context = $table.data("context");
    $table.find("tbody tr :nth-child(" + column + ")")
      .removeClass("table-" + context)
      .removeClass("dull-selected-cell")
      .trigger("change");
  });
});
