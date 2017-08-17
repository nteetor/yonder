#' Stream notifications
#'
#' The stream output is used to send updates to the user during long-running
#' processes. Unlike conventional reactive outputs, the stream output does not
#' have a render function instead messages are sent with `sendStreamMessage`.
#'
#' @param id A character string specifying the id of the stream output.
#'
#' @param message A character string specifying an update message.
#'
#' @param context One of `"secondary"`, `"success"`, `"info"`, `"warning"`, or
#'   `"danger"` specifying the visual context of the button input, defaults to
#'   `"secondary"`.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [`getDefaultReactiveDomain()`].
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           buttonInput(id = "trigger", "Go!")
#'         ),
#'         col(
#'           streamOutput(
#'             id = "stream"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$trigger, {
#'         for (i in seq_len(5)) {
#'           updateStream(
#'             id = "stream",
#'             message = paste("Update:", i),
#'             context = if (i %% 2) "warning" else "info"
#'           )
#'           Sys.sleep(1)
#'         }
#'       })
#'     }
#'   )
#' }
#'
streamOutput <- function(id, ...) {
  tags$ul(
    class = collate(
      "dull-stream-output",
      "list-group"
    ),
    id = id,
    ...
  )
}

#' @rdname streamOutput
#' @export
sendStreamMessage <- function(id, message, context = NULL,
                              session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `sendStreamMessage` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (!re(context, "secondary|success|info|warning|danger|link|primary", len0 = FALSE)) {
    stop(
      "invalid `sendStreamMessage` argument, `context` must be one of ",
      '"secondary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendProgress(
    "dull",
    list(
      id = paste0("#", id),
      message = message,
      context = context
    )
  )
}
