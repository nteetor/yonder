#' Table thruput
#'
#' Render a table. Thruputs are a new reactive object.
#'
#' @param id A character string specifying the id of the table thruput.
#'
#' @param borders If `TRUE`, the table renders with cell borders, defaults to
#'   `FALSE`.
#'
#' @param compact If `TRUE`, table cell padding is cut in half to reduce the
#'   size of the table, defaults to `FALSE`.
#'
#' @param context One `"success"`, `"info"`, `"warning"`, `"danger"`, specifying
#'   the context of selected table rows, defaults to `NULL`, in which case
#'   selected rows are highlighted in grey.
#'
#' @param expr An expression which returns a data frame or `NULL`. If data frame
#'   the table thruput is re-rendered, otherwise if `NULL` the current table
#'   thruput is left as is.
#'
#' @param quoted If `TRUE`, then `expr` is treated as a quoted expression,
#'   defaults to `FALSE`.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [`getDefaultReactiveDomain()`].
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
#'       output$table <- renderTable({
#'         iris[1:10, ]
#'       })
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
#'       output$tbl <- renderTable({
#'         iris[1:10, ]
#'       })
#'
#'       output$subset <- renderTable({
#'         input$tbl
#'       })
#'     }
#'   )
#' }
#'
#'
tableThruput <- function(id, borders = FALSE, compact = FALSE, ...) {
  if (!is.null(id) || !is.character(id)) {
    stop(
      "invalid `tableThruput` argument, `id` must be a character string or ",
      "NULL",
      call. = FALSE
    )
  }

  tags$table(
    class = collate(
      "dull-table-thruput",
      "table",
      if (is.character(id)) "table-hover",
      "table-responsive",
      if (borders) "table-bordered",
      if (compact) "table-sm"
    ),
    id = id,
    ...
  )
}

#' @rdname tableThruput
#' @export
renderTable <- function(expr, env = parent.frame(), quoted = FALSE) {
  dfFunc <- shiny::exprToFunction(expr, env, quoted)

  function() {
    df <- dfFunc()

    if (is.null(df)) {
      return(list())
    }

    if (!is.data.frame(df)) {
      stop(
        "invalid `renderTable` value, `expr` returned " + class(df) +
        ", expecting data frame",
        call. = FALSE
      )
    }

    return(
      list(
        columns = colnames(df) %||% rep("", NCOL(df)),
        data = jsonlite::toJSON(df)
      )
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
