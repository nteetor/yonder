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
#' @param context An expression which returns one of `"primary"`, `"secondary"`,
#'   `"success"`, `"info"`, `"warning"`, `"danger"`, `"light"`, or `"dark"`. The
#'   expression may contain reactive values.
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
#'           offset = 3,
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
badgeOutput <- function(id, content, context = "secondary", ...) {
  if (!is.character(id)) {
    stop(
      "invalid `badgeOutput` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (!re(context, "primary|secondary|success|info|warning|danger|dark|light")) {
    stop(
      "invalid `renderBadge` argument, `context` expression must return ",
      "one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", or "dark"',
      call. = FALSE
    )
  }

  tags$span(
    class = collate(
      "dull-badge-output",
      "badge",
      "badge-default"
    ),
    id = id,
    content,
    ...
  )
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(content, context = "secondary", env = parent.frame(),
                        quoted = FALSE) {
  valFun <- shiny::exprToFunction(content, env, quoted)
  conFun <- shiny::exprToFunction(context, env, quoted)

  function() {
    con <- conFun()

    if (!re(con, "primary|secondary|success|info|warning|danger|dark|light", FALSE)) {
      stop(
        "invalid `renderBadge` argument, `context` expression must return ",
        "one of ",
        '"primary", "secondary", "success", "info", "warning", "danger", ',
        '"light", or "dark"',
        call. = FALSE
      )
    }

    list(
      value = valFun(),
      context = con
    )
  }
}
