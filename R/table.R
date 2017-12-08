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
#' @param context One `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, `"light"`, `"dark"`, or `NULL` specifying the
#'   visual context of the table, defaults to `NULL`, in which case a visual
#'   context is not applied.
#'
#' @param expr An expression which returns a data frame or `NULL`. If a data
#'   frame is returned the table thruput is re-rendered, otherwise if `NULL` the
#'   current table thruput is left as is.
#'
#' @param quoted If `TRUE`, then `expr` is treated as a quoted expression,
#'   defaults to `FALSE`.
#'
#' @param state One of `"valid"`, "success"`, `"warning"`, or `"danger"`
#'   indicating the state of the table row. If `"valid"` then the visual context
#'   is removed.
#'
#' @param validate A numeric vector or list of row numbers indicating which
#'   table rows to mark as `state`, defaults to `NULL`. If `NULL` then all rows
#'   are marked as `state`.
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
#'             id = "table",
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
#'       output$table <- renderTable({
#'         mtcars[1:10, ]
#'       })
#'
#'       output$subset <- renderTable({
#'         input$table
#'       })
#'     }
#'   )
#' }
#'
tableThruput <- function(id, borders = FALSE, context = NULL, compact = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `tableThruput` argument, `id` must be a character string or ",
      "NULL",
      call. = FALSE
    )
  }

  if (!re(context, "primary|secondary|success|info|warning|danger|light|dark")) {
    stop(
      "invalid `tableThruput` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", or NULL',
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
      if (compact) "table-sm",
      `data-table` = if (!is.null(context)) paste0("table-", context)
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
        columns = as.list(colnames(df) %||% rep("", NCOL(df))),
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
