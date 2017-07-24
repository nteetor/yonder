#' Badges, tags
#'
#' A badge is a useful means of highlighting text.
#'
#' @param content The text or label of the badge, defaults to `NULL`.
#'
#' @param context A character string specifying the visual context of the badge,
#'   one of `"primary"`, `"success"`, `"info"`, `"warning"`, or `"danger"`,
#'   defaults to `NULL`.
#'
#' @param pill If `TRUE` the badge has rounder corners, defaults to `FALSE`.
#'
#' @param ... Additional named argument passed on as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroup(
#'         listGroupItem(
#'           label = "Button clicks",
#'           badge = badge(
#'             id = "buttonClicks",
#'             content = 0
#'           )
#'         )
#'       ),
#'       button(
#'         id = "myButton",
#'         "Click here!"
#'       )
#'     ),
#'     server = function(input, output) {
#'       numClicks <- 0
#'       output$buttonClicks <- renderBadge({
#'         req(input$myButton)
#'         numClicks <<- numClicks + 1
#'         numClicks
#'       }, {
#'         if (numClicks > 19) {
#'           "danger"
#'         } else if (numClicks > 9) {
#'           "warning"
#'         } else {
#'           "info"
#'         }
#'       })
#'     }
#'   )
#' }
#'
badge <- function(content = NULL, context = NULL, pill = FALSE, ...) {
  if (bad_context(context, extra = c("primary", "default"))) {
    stop(
      '`badge` argument `context` must be one of "default", "primary", ',
      '"success", "info", "warning", or "danger"', call. = FALSE
    )
  }

  context <- context %||% "default"

  tags$span(
    class = collate(
      "dull-badge",
      "badge",
      paste0("badge-", context),
      if (pill) "badge-pill"
    ),
    content,
    ...
  )
}

#' @rdname badge
#' @export
renderBadge <- function(value, context = NULL, env = parent.frame(), quoted = FALSE) {
  valFun <- shiny::exprToFunction(value, env, quoted)
  conFun <- shiny::exprToFunction(context, env, quoted)

  function() {
    list(
      value = valFun(),
      context = conFun()
    )
  }
}
