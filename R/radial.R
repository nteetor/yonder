#' Radial output
#'
#' A radial output, suitable for precentages.
#'
#' @param id A character string specifying the id of the output.
#'
#' @param expr An expression.
#'
#' @param env The evaluation environment.
#'
#' @param quoted Is `expr` quoted?
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       radialOutput("radial")
#'     ),
#'     server = function(input, output) {
#'       output$radial <- renderRadial({
#'
#'       })
#'     }
#'   )
#' }
#'
radialOutput <- function(id) {
  tags$div(
    class = "dull-radial-output chart",
    id = id,
    d3()
  )
}

#' @rdname radialOutput
#' @export
renderRadial <- function(expr, env = parent.frame(), quoted = FALSE) {
  fun <- shiny::exprToFunction(expr, env, quoted)

  function() {
    list(
      result = fun()
    )
  }
}
