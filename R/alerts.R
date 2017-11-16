#' Alerts
#'
#' Trigger one or more alerts. Use alerts to let the user know of successes
#' or to call attention to problems.
#'
#' @param id A character vector of id(s). Alerts are inserted above the elements
#'   with these ids.
#'
#' @param content A character string specifying the body of the alert or
#'   a custom element to include as the body of the alert.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, `"light"`, or `"dark"` specifying the visual
#'   context of the alert, defaults to `"secondary"`.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [`getDefaultReactiveDomain()`].
#'
#' @seealso
#'
#' Boostrap 4 alert documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/alerts/}
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput(id = "button", "A button")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$button, {
#'         sendAlert(
#'           id = "button",
#'           content = "You clicked the button!",
#'           context = "warning"
#'         )
#'       })
#'     }
#'   )
#' }
#'
sendAlert <- function(id, content, context = "secondary",
                      session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `sendAlert` argument, `id` must be a character string or vector",
      call. = FALSE
    )
  }

  if (!re(context, "primary|secondary|success|info|warning|danger|dark|light", FALSE)) {
    stop(
      "invalid `sendAlert` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", or "dark"',
      call. = FALSE
    )
  }

  session$sendCustomMessage(
    "dull:alert",
    list(
      id = as.list(id),
      content = htmltools::HTML(content),
      context = context
    )
  )
}
