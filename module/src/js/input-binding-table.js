var tableInputBinding = new Shiny.InputBinding();

$.extend(tableInputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function(el) {
    return el.id;
  },
  getType: function(el) {
    return "dull.table.input";
  },
  getValue: function(el) {
    var $el = $(el);

    var columns = $el.find("thead th").map((i, e) => $(e).text()).get();

    var value = $el.find("tr")
      .filter((i, e) => $(e).hasClass("table-active"))
      .map(function(i, row) {
        var obj = {};

        $(row).children("td").each(function(j, cell) {
          obj[columns[j + 1]] = $(cell).text();
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
    $(el).on("click.tableInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".tableInputBinding");
  },
  receiveMessage: function(el, data) {
    var $el = $(el);

    if (data.validate) {
      $.each(data.validate, function(i, index) {
        $el.find("tbody tr:nth-child(" + index + ")")
          .addClass("table-" + data.state);
      });
    }
  }
});

Shiny.inputBindings.register(tableInputBinding, "dull.tableInput");

$(document).ready(function() {
  $(".dull-table-thruput[id]").on("click", "tbody tr", function(e) {
    $(this).toggleClass("table-active");
  });
});
