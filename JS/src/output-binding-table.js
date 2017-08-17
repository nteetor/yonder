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
              return $("<th>").text(col);
            })
          )
        ),
        $("<tbody>").append(
          $.map(data.data, (row, i) => {
            return $("<tr>").append(
              $("<th>").text(i + 1).attr("scope", "row"),
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
