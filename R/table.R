#' Table output
#'
#' Render a table.
#'
#' @param id A character string specifying the id of the table output.
#'
#' @param borders If `TRUE`, the table renders with borders, defaults to
#'   `FALSE`.
#'
#' @param compact If `TRUE`, table cell padding is cut in half to reduce the
#'   size of the table, defaults to `FALSE`.
#'
#' @param invert If `TRUE`, the table renders with a dark background, light
#'   text, and any borders are light, defaults to `FALSE`.
#'
#' @param striped If `TRUE`, the table renders with a striped pattern, defaults
#'   to `FALSE`.
#'
#' @param hoverable If `TRUE`, each table row has a hover state, defaults to
#'   `FALSE`.
#'
#' @param context One `"success"`, `"info"`, `"warning"`, `"danger"`, specifying
#'   the context of selected table rows, defaults to `NULL`, in which case
#'   selected rows are highlighted in grey.
#'
#' @param responsive If `TRUE`, the table will scroll horizontally on small
#'   viewports, viewports under 768 pixels, defaults to `TRUE`. There is no
#'   effect when the viewport height is greater than 768 pixels.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tableThruput(
#'             id = "table",
#'             context = "danger"
#'           )
#'         ),
#'         col(
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$table <- renderTable(
#'         numbered = TRUE,
#'         iris[1:10, ]
#'       )
#'
#'       output$value <- renderPrint({
#'         input$table
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tableThruput(
#'             id = "tbl",
#'             hoverable = TRUE,
#'             context = "warning",
#'             borders = TRUE
#'           )
#'         ),
#'         col(
#'           tableThruput(
#'             id = "subset",
#'             borders = TRUE
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$tbl <- renderTable(
#'         numbered = TRUE,
#'         iris[1:10, ]
#'       )
#'
#'       output$subset <- renderTable(
#'         numbered = TRUE,
#'         input$tbl
#'       )
#'     }
#'   )
#' }
#'
#'
tableThruput <- function(id, borders = FALSE, compact = FALSE, invert = FALSE,
                        striped = FALSE, hoverable = FALSE, context = NULL,
                        responsive = TRUE, ...) {
  if (!re(context, "success|info|warning|danger")) {
    stop(
      "invalid `tableThruput` argument, `context` must be one of ",
      '"success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }
  tags$table(
    class = collate(
      "dull-table-thruput",
      "table",
      if (invert) "table-invert",
      if (striped) "table-striped",
      if (borders) "table-bordered",
      if (hoverable) "table-hover",
      if (compact) "table-sm",
      if (responsive) "table-responsive"
    ),
    `data-context` = context %||% "active",
    id = id,
    ...,
    `font-awesome`()
  )
}

#' @rdname tableThruput
#' @export
renderTable <- function(expr, numbered = FALSE, env = parent.frame(),
                        quoted = FALSE) {
  tableFunc <- shiny::exprToFunction(expr, env, quoted)

  function() {
    tbl <- tableFunc()

    if (is.null(tbl)) {
      return(
        list(
          content = NULL
        )
      )
    }

    if (!is.data.frame(tbl)) {
      stop(
        "invalid `renderTable` return value, `expr` returned " + class(tbl) +
        ", expecting a data frame",
        call. = FALSE
      )
    }

    headers <- tags$thead(
      tags$tr(
        if (numbered) tags$th(scope = "col", "#"),
        lapply(
          colnames(tbl),
          function(col) tags$th(
            class = "column-header",
            col,
            fontAwesome(class = "column-selector", "plus"),
            fontAwesome(class = "column-deselector", "minus")
          )
        )
      )
    )

    body <- tags$tbody(
      lapply(
        seq_len(NROW(tbl)),
        function(row) {
          tags$tr(
            if (numbered) tags$th(
              class = "row-selector",
              scope = "row",
              row
            ),
            lapply(
              colnames(tbl),
              function(col) {
                tags$td(
                  `data-col` = col,
                  tbl[row, col, drop = FALSE]
                )
              }
            )
          )
        }
      )
    )

    list(
      content = paste0(headers, body)
    )
  }
}

shiny::registerInputHandler(
  type = "dull.table.input",
  fun = function(x, session, name) {
    frame <- jsonlite::fromJSON(x)

    if (NROW(frame) == 0 || NCOL(frame) == 0) {
      return(NULL)
    }

    frame
  },
  force = TRUE
)
