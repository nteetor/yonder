#' Badge outputs
#'
#' Small highlighted content which scales to its parent's size. Useful for
#' displaying dynamically changing counts or tickers, drawing attention to new
#' options, or tagging content.
#'
#' @param id A character string specifying the id of the badge, defaults to
#'   `NULL`. An id must be specified in order to use `renderBadge` in the shiny
#'   server function.
#'
#' @param content A character string specifying the text or label of the badge,
#'   defaults to `NULL`.
#'
#' @param context A character string specifying the visual context of the badge,
#'   one of `"default"`, `"primary"`, `"success"`, `"info"`, `"warning"`, or
#'   `"danger"`, defaults to `"default"`.
#'
#' @param rounded If `TRUE` the badge has more rounded corners, defaults to
#'   `FALSE`.
#'
#' @param ... Additional named argument passed on as HTML attributes to the
#'   parent element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroupInput(
#'         listGroupItem(
#'           label = "Button clicks",
#'           badge = badgeOutput(
#'             id = "clicks",
#'             content = 0
#'           )
#'         )
#'       ),
#'       buttonInput(
#'         id = "clicker",
#'         "Click here!"
#'       )
#'     ),
#'     server = function(input, output) {
#'       count <- 0
#'
#'       output$clicks <- renderBadge(
#'         content = {
#'           req(input$clicker)
#'           count <<- count + 1
#'           count
#'         },
#'         context = {
#'           if (count > 19) {
#'             "danger"
#'           } else if (count > 9) {
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
badgeOutput <- function(content = NULL, context = "default", rounded = FALSE,
                        ..., id = NULL) {
  if (!re(context, "default|primary|success|info|warning|danger", len0 = FALSE)) {
    stop(
      "`badgeOutput` argument `context` must be one of ",
      '"default", "primary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  tags$span(
    class = collate(
      "dull-badge",
      "badge",
      paste0("badge-", context),
      if (pill) "badge-pill"
    ),
    content,
    ...,
    id = id
  )
}

#' @rdname badgeOutput
#' @export
renderBadge <- function(value, context = NULL, env = parent.frame(),
                        quoted = FALSE) {
  valFun <- shiny::exprToFunction(value, env, quoted)
  conFun <- shiny::exprToFunction(context, env, quoted)

  function() {
    list(
      value = valFun(),
      context = conFun()
    )
  }
}
