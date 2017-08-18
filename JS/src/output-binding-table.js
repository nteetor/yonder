var tableOutputBinding = new Shiny.OutputBinding();

$.extend(tableOutputBinding, {
  find: function(scope) {
    return $(scope).find(".dull-table-thruput[id]");
  },
  getId: function(el) {
    return el.id;
  },
  renderValue: function(el, data) {
    var $el = $(el);

    if (data.data && data.columns) {
      $el.empty();

      $el.append(
        $("<thead>").append(
          $("<tr>").append(
            $("<th>").text("#"),
            $.map(data.columns, (col, i) => {
              return $("<th>").addClass("thead-default").text(col);
            })
          )
        ),
        $("<tbody>").append(
          $.map(data.data, (row, i) => {
            var heading;
            if ("_row" in row) {
              heading = $("<th>").text(row._row).attr("scope", "row");
              delete row._row;
            } else {
              heading = $("<th>").text(i + 1).attr("scope", "row");
            }

            return $("<tr>").append(
              heading,
              $.map(Object.entries(row), ([key, value], i) => {
                return $("<td>").text(value).data("col", key);
              })
            );
          })
        )
      );
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");
