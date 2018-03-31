#' Static and actionable alerts
#'
#' Use `showAlert` to let the user know of successes or to call attention to
#' problems. While alerts are static by default they can also be made
#' actionable. Actionable alerts can be used for undoing or redoing an action
#' and more.
#'
#' @param text A character string specifying the message text of the alert.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   alert element.
#'
#' @param duration A positive integer specifying the duration of the alert,
#'   by default the alert is removed after 4 seconds.
#'
#' @param color A character string specifying the color of the alert,
#'   for possible colors see [background].
#'
#' @param action A character string specifying a reactive id. If specified a
#'   button is added to the alert. If clicked the reactive value
#'   `input[[action]]` is set to `TRUE`. When the alert is removed
#'   `input[[action]]` is reset to `NULL`.
#'
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
#'         showAlert("Alert", color = color, action = "undo")
#'       })
#'
#'       observeEvent(input$undo, {
#'         print("OOOOOOHHH yes!")
#'       })
#'     }
#'   )
#' }
#'
showAlert <- function(text, ..., duration = 4, color = NULL, action = NULL) {
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
    duration = duration * 1000,
    color = color,
    action = action,
    attrs = if (length(attrs)) attrs
  ))
}
