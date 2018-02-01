#' Badge outputs
#'
#' Small highlighted content which scales to its parent's size. Useful for
#' displaying dynamically changing counts or tickers, drawing attention to new
#' options, or tagging content.
#'
#' @param id A character string specifying the id of the badge output.
#'
#' @param content A character string specifying the content of the badge or an
#'   expression which returns a character string.
#'
#' @param ... Additional named argument passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(
#'             id = "button",
#'             label = list(
#'               "Number of clicks: ",
#'               badgeOutput("clicks", 0) %>%
#'                 background("pink") %>%
#'                 darken(4)
#'             )
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$clicks <- renderBadge({
#'         input$button
#'       })
#'     }
#'   )
#' }
#'
badgeOutput <- function(id, content, ...) {
  if (!is.character(id)) {
    stop(
      "invalid `badgeOutput` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  tags$span(
    class = "dull-badge-output badge",
    id = id,
    content,
    ...
  )
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(content, env = parent.frame(), quoted = FALSE) {
  valFun <- shiny::exprToFunction(content, env, quoted)

  function() {
    list(
      value = valFun()
    )
  }
}
