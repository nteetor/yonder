#' A chartist thruput
#'
#' **Under development**. A reactive chart control.
#'
#' @param id A character string specifying the id of the thruput control.
#'
#' @examples
#'
#' shinyApp(
#'   ui = container(
#'     row(
#'       col(
#'         chartistThruput("test")
#'       )
#'     )
#'   ),
#'   server = function(input, output) {
#'
#'   }
#' )
#'
chartistThruput <- function(id) {
  NULL
}

renderChartist <- function(expr, env = parent.frame(), quoted = FALSE) {
  fun <- shiny::exprToFunction(expr, env, quoted)

  function() {
    fun()
  }
}
