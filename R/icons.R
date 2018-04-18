#' A spinner
#'
#' Start or stop a spinner based on process progress.
#'
#' @param id A character specifying the id of the spinner output.
#'
#' @param type One of `"circle"`, `"cog"`, `"dots"`, or `"sync"` specifying the
#'   type of spinner, defaults to `"circle"`.
#'
#' @param pulse One of `TRUE` or `FALSE`, if `TRUE` the spinner rotates in 8
#'   discrete steps, defaults to `FALSE`.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       col(
#'         spinnerOutput("spin", pulse = TRUE),
#'         buttonInput("trigger", "Start/stop")
#'       ) %>%
#'         display("flex") %>%
#'         content("around")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$trigger, {
#'         if (input$trigger %% 2 == 1) {
#'           startSpinner("spin")
#'         } else {
#'           stopSpinner("spin")
#'         }
#'       })
#'     }
#'   )
#' }
#'
spinnerOutput <- function(id, type = "circle", pulse = FALSE, ...) {
  tags$i(
    class = collate(
      "dull-spinner-output",
      "fas",
      switch(
        type,
        circle = "fa-circle-notch",
        cog = "fa-cog",
        dots = "fa-spinner",
        sync = "fa-sync"
      ),
      if (pulse) "fa-pulse" else "fa-spin",
      "pause"
    ),
    id = id,
    ...,
    includes()
  )
}

#' @rdname spinnerOutput
#' @export
startSpinner <- function(id, session = getDefaultReactiveDomain()) {
  session$sendProgress("dull-spinner", list(
    id = id,
    action = "start"
  ))
}

#' @rdname spinnerOutput
#' @export
stopSpinner <- function(id, session = getDefaultReactiveDomain()) {
  session$sendProgress("dull-spinner", list(
    id = id,
    action = "stop"
  ))
}
