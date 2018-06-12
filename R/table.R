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
#' @param responsive One of `TRUE` or `FALSE` specifying if the table is allowed
#'   to scroll horizontally, default to `FALSE`. This is useful when fitting
#'   wide tables on small screens.
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
#'         column(
#'           width = 6,
#'           tableThruput(
#'             id = "table1",
#'             responsive = TRUE,
#'             editable = TRUE
#'           )
#'         ),
#'         column(
#'           width = 6,
#'           verbatimTextOutput("value")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$table1 <- renderTable({
#'         iris
#'       })
#'
#'       output$value <- renderPrint({
#'         input$table1
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           tableThruput(
#'             id = "table1",
#'             borders = TRUE,
#'             responsive = TRUE
#'           )
#'         ),
#'         column(
#'           tableThruput(
#'             id = "table2",
#'             borders = TRUE,
#'             responsive = TRUE
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$table1 <- renderTable({
#'         mtcars[1:10, ]
#'       })
#'
#'       output$table2 <- renderTable({
#'         input$table1
#'       })
#'     }
#'   )
#' }
#'
tableThruput <- function(id, ..., borders = FALSE, compact = FALSE,
                         responsive = FALSE, editable = FALSE) {
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
      x <- jsonlite::fromJSON(x)

      if (!(NROW(x) || NCOL(x))) {
        return(NULL)
      }

      x
    },
    force = TRUE
  )

  tags$table(
    class = collate(
      "dull-table-thruput",
      "table",
      if (borders) "table-bordered",
      if (compact) "table-sm"
    ),
    id = id,
    `data-responsive` = if (responsive) "true",
    `data-editable` = if (editable) "true" else "false",
    ...,
    include("core")
    # include("chabudai")
  )
}

#' @rdname tableThruput
#' @export
renderTable <- function(expr, env = parent.frame(), quoted = FALSE) {
  installExprFunction(expr, "func", env, quoted)

  createRenderFunction(
    func,
    function(data, session, name) {
      list(data = jsonlite::toJSON(data, na = "string"))
    },
    tableOutput
  )
}
