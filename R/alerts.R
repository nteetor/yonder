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
#'           content = "You clicked the button!"
#'         )
#'       })
#'     }
#'   )
#' }
#'
sendAlert <- function(id, content, session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `sendAlert` argument, `id` must be a character string or vector",
      call. = FALSE
    )
  }

  session$sendCustomMessage(
    "dull:alert",
    list(
      id = as.list(id),
      content = htmltools::HTML(content)
    )
  )
}
