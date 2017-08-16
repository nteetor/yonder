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

    if (data.data) {
      $el.empty();

      $el.append(
        $("<thead>").append(
          $("<tr>").append(
            $("<th>").text("#"),
            $.map(Object.keys(data.data[1]), (header, i) => {
              return $("<th>").text(header);
            })
          )
        ),
        $("<tbody>").append(
          $.map(data.data, (row, i) => {
            return $("<tr>").addClass("data-row").append(
              $("<th>").text(i + 1).attr("scope", "row").addClass("util-cell"),
              $.map(Object.entries(row), ([key, value], i) => {
                return $("<td>").addClass("data-cell").text(value)
                  .data("col", key);
              }),
              $("<td>").addClass("selector-cell").append(
                $("<i>").addClass("px-1 fa fa-plus row-selector"),
                $("<i>").addClass("px-1 fa fa-minus row-deselector")
              )
            );
          }),
          $("<tr>").addClass("selector-row").append(
            $("<th>"),
            $.map(data.data[1], () => {
               return $("<td>").addClass("selector-cell")
                 .append(
                   $("<i>").addClass("px-1 fa fa-plus column-selector"),
                   $("<i>").addClass("px-1 fa fa-minus column-deselector")
                 );
            }),
            $("<td>")
//            .addClass("centered").append(
//              $("<i>").addClass("fa fa-table table-toggle").data("on", true)
//            )
          )
        )
      );
    }
  }
});

Shiny.outputBindings.register(tableOutputBinding, "dull.tableOutput");
