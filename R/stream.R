#' Stream notifications
#'
#' The stream output is used to send updates to the user during long-running
#' processes. Unlike conventional reactive outputs, the stream output does not
#' have a render function instead messages are sent with `sendStreamMessage`.
#' This allows message to "render" during long-running observers or other
#' processes.
#'
#' @param id A character string specifying the id of the stream output.
#'
#' @param message A character string specifying the message text.
#'
#' @param context One of `"success"`, `"info"`, `"warning"`, or `"danger"`
#'   specifying the visual context of the message, defaults to NULL, in which
#'   case no visual context is applied.
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
#'           sendStreamMessage(
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

  if (!re(context, "success|info|warning|danger")) {
    stop(
      "invalid `sendStreamMessage` argument, `context` must be one of ",
      '"secondary", "success", "info", "warning", or "danger"',
      call. = FALSE
    )
  }

  session$sendProgress(
    "dull",
    list(
      id = id,
      message = message,
      context = context
    )
  )
}
