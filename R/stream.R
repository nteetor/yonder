#' Stream notifications
#'
#' The stream output is used to send updates to the user during long-running
#' processes. Unlike conventional reactive outputs, the stream output does not
#' have a render function. Instead messages are sent with `sendStream`. This
#' allows message to "render" during long-running observers or other processes.
#'
#' @param id A character string specifying the id of the stream output.
#'
#' @param content A character string specifying the message text.
#'
#' @param session A `session` object passed to the shiny server function,
#'   defaults to [getDefaultReactiveDomain()].
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @family outputs
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           buttonInput(id = "trigger", "Go!")
#'         ),
#'         column(
#'           streamOutput(
#'             id = "stream"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$trigger, {
#'         for (i in seq_len(5)) {
#'           sendStream(
#'             id = "stream",
#'             content = paste("Update:", i)
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
      "yonder-stream",
      "list-group"
    ),
    id = id,
    ...
  )
}

#' @rdname streamOutput
#' @export
sendStream <- function(id, content,
                       session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `sendStream` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  session$sendProgress(
    "yonder-stream",
    list(
      id = id,
      content = content
    )
  )
}
