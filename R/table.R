#' Table thruput
#'
#' Render a table. Thruputs are a new reactive object.
#'
#' @param id A character string specifying the id of the table thruput.
#'
#' @param borders One of `TRUE` or `FALSE` specifying if the table renders with
#'   cell borders, defaults to `FALSE`.
#'
#' @param compact One of `TRUE` or `FALSE` specifying if the table cells are
#'   rendered with less space, defaults to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param expr An expression which returns a data frame or `NULL`. If a data
#'   frame is returned the table thruput is re-rendered, otherwise if `NULL` the
#'   current table is left as is.
#'
#' @param env The environment in which to evaluate `expr`, defaults to
#'   `parent.frame()`.
#'
#' @param quoted One of `TRUE` or `FALSE` specifying if `expr` is a quoted
#'   expression.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           tableThruput(
#'             id = "table"
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
tableThruput <- function(id, borders = FALSE, compact = FALSE, ...) {
  if (!is.null(id) && !is.character(id)) {
    stop(
      "invalid `tableThruput` argument, `id` must be a character string or ",
      "NULL",
      call. = FALSE
    )
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
        "invalid `renderTable` value, `expr` returned ", class(df),
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
