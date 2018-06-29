#' Badge outputs
#'
#' Small highlighted content which scales to its parent's size. Useful for
#' displaying dynamically changing counts or tickers, drawing attention to new
#' options, or tagging content.
#'
#' @param id A character string specifying the id of the badge output.
#'
#' @param ... Additional named argument passed as HTML attributes to the parent
#'   element.
#'
#' @param expr An expression which returns a character string specifying the
#'   label of the badge.
#'
#' @param env The environment in which to evaluate `expr`, defaults to the
#'   calling environment.
#'
#' @param quoted One of `TRUE` or `FALSE` specifying if `expr` is a quoted
#'   expression.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           buttonInput(
#'             id = "mybutton",
#'             label = list(
#'               "Number of clicks: ",
#'               badgeOutput("clicks") %>%
#'                 background("red")
#'             )
#'           ),
#'           badgeOutput("another")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$another <- renderBadge({
#'         200
#'       })
#'
#'       output$clicks <- renderBadge({
#'         input$mybutton
#'       })
#'     }
#'   )
#' }
#'
badgeOutput <- function(id, ...) {
  if (!is.character(id)) {
    stop(
      "invalid `badgeOutput()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  tags$span(
    class = "dull-badge-output badge",
    id = id,
    ...,
    include("core")
  )
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(expr, env = parent.frame(), quoted = FALSE) {
  installExprFunction(expr, "func", env, quoted)

  createRenderFunction(
    func,
    function(data, session, name) {
      list(data = data)
    },
    badgeOutput
  )
}
