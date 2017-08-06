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
#' @param rounded If `TRUE` the badge appears in a pill instead of a rectangular
#'   shape, defaults to `FALSE`.
#'
#' @param context An expression which returns one of `"default"`, `"success"`,
#'   `"info"`, `"warning"`, or `"danger"`. The expression may contain reactive
#'   values.
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
#'           listGroupInput(
#'             id = NULL,
#'             items = "Button clicks",
#'             badges = list(
#'               badgeOutput(
#'                 id = "clicks",
#'                 content = 0
#'               )
#'             )
#'           )
#'         ),
#'         col(
#'           buttonInput(
#'             id = "clicker",
#'             "Click here!"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$clicks <- renderBadge(
#'         content = {
#'           input$clicker
#'         },
#'         context = {
#'           req(input$clicker)
#'
#'           clicks <- input$clicker
#'
#'           if (clicks > 19) {
#'             "danger"
#'           } else if (clicks > 9) {
#'             "warning"
#'           } else {
#'             "info"
#'           }
#'         }
#'       )
#'     }
#'   )
#' }
#'
badgeOutput <- function(id, content, rounded = FALSE, ...) {
  if (!is.character(id)) {
    stop(
      "invalid `badgeOutput` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  tags$span(
    class = collate(
      "dull-badge-output",
      "badge",
      "badge-default",
      if (rounded) "badge-pill"
    ),
    id = id,
    content,
    ...
  )
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(content, context = NULL, env = parent.frame(),
                        quoted = FALSE) {
  valFun <- shiny::exprToFunction(content, env, quoted)
  conFun <- shiny::exprToFunction(context, env, quoted)

  function() {
    con <- conFun()

    if (!re(con, "default|primary|success|info|warning|danger")) {
      stop(
        "invalid `renderBadge` argument, `context` expression must return one of ",
        '"default", "success", "info", "warning", or "danger"',
        call. = FALSE
      )
    }

    list(
      value = valFun(),
      context = con
    )
  }
}
