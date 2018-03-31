#' Show an alert
#'
#' Use `showAlert` to let the user know of successes or to call attention to
#' problems.
#'
#' @param text A character string specifying the message text of the alert.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   alert element.
#'
#' @param color A character string specifying the color of the alert,
#'   for possible colors see [background].
#'
#' @param duration A positive integer specifying the duration of the alert,
#'   by default the alert is removed after 4 seconds.
#'
#' @seealso
#'
#' Boostrap 4 alert documentation:
#' \url{https://getbootstrap.com/docs/4.0/components/alerts/}
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput("show", "Alert!")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$show, {
#'         color <- sample(c("teal", "red", "orange", "blue"), 1)
#'         showAlert("Alert", color = color)
#'       })
#'     }
#'   )
#' }
#'
showAlert <- function(text, ..., color = NULL, duration = 4) {
  domain <- getDefaultReactiveDomain()

  if (is.null(domain)) {
    stop(
      "function `showAlert` must be called in a reactive context",
      call. = FALSE
    )
  }

  if (!(color %in% .colors)) {
    stop(
      "invalid `showAlert()` argument, unrecognized `color` , see ?background ",
      "for possible values",
      call. = FALSE
    )
  }

  text <- as.character(text)

  if (length(text) != 1) {
    stop(
      "invalid `showAlert()` argument, expecting `text` to be a character ",
      "string",
      call. = FALSE
    )
  }

  if (!is.numeric(duration) || duration <= 0) {
    stop(
      "invalid `showAlert()` argument, expecting `duration` to be a positive ",
      "integer",
      call. = FALSE
    )
  }

  args <- list(...)
  attrs <- attribs(args)

  domain$sendInputMessage("alert-container", list(
    text = text,
    color = color,
    duration = duration * 1000,
    attrs = if (length(attrs)) attrs
  ))
}
