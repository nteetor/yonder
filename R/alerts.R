#' Send and add alerts
#'
#' `sendAlert`
#'
#' @param id A character vector of HTML id(s) where the alert(s) will be
#'   inserted.
#'
#' @param content A character string specifying the body of the alert or
#'   a custom element to include as the body of the alert.
#'
#' @param context One of `"success"`, `"info"`, `"warning"`, or `"danger"`
#'   specifying the visual context of the alert, defaults to `"secondary"`.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [`getDefaultReactiveDomain()`].
#'
#' @seealso
#'
#' For more information on bootstrap alerts please refer to the
#' [reference page](https://v4-alpha.getbootstrap.com/components/alerts/).
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       `font-awesome`(),
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

  if (!re(context, "primary|secondary|success|info|warning|danger", FALSE)) {
    stop(
      "invalid `sendAlert` argument, `context` must be one of ",
      '"success", "info", "warning", or "danger"',
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
