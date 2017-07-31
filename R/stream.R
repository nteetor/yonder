#' Stream notifications
#'
#' These functionalities allow an application to convey text progress updates
#' to the user during long running processes.
#'
#' @param id A character string specifying the id of the stream output.
#'
#' @param message A character string specifying an update message.
#'
#' @param template A call `listGroupItem` which is used as a template for the
#'   message sent, any body element(s) or text of the item are replaced by
#'   `message`, defaults to `listGroupItem()`.
#'
#' @param session The shiny session, defaults to the default reactive domain.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput(id = "trigger", "Go!"),
#'       tags$div(
#'         id = "myStream"
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$trigger, {
#'         for (i in seq_len(5)) {
#'           updateStream(
#'             id = "myStream",
#'             message = paste("Update:", i),
#'             template = listGroupItem(
#'               context = if (i %% 2) "warning" else "info"
#'             )
#'           )
#'           Sys.sleep(1);
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
updateStream <- function(id, message, template = listGroupItem(),
                         session = getDefaultReactiveDomain()) {
  if (!tagHasClass(template, "list-group-item")) {
    warning(
      "unconventional `updateStream` argument value, `template` usually is a ",
      "call to `listGroupItem`",
      call. = FALSE
    )
  }

  session$sendProgress(
    "dull",
    list(
      id = paste0("#", id),
      content = message,
      template = HTML(as.character(template %||% listGroupItem()))
    )
  )
}
