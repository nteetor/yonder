#' Stream notifications
#'
#' These functionalities allow an application to convey text progress updates
#' to the user during long running processes.
#'
#' @param id A character string specifying the id of the stream output.
#'
#' @param msg A character string specifying an update message.
#'
#' @param session The shiny session, defaults to the default reactive domain.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       button(id = "trigger", "Go!"),
#'       tags$div(
#'         id = "myStream"
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$trigger, {
#'         for (i in seq_len(5)) {
#'           updateStream("myStream", paste("Update:", i))
#'           Sys.sleep(1);
#'         }
#'       })
#'     }
#'   )
#' }
#'
updateStream <- function(id, msg, session = getDefaultReactiveDomain()) {
  session$sendProgress(
    "dull",
    list(
      id = paste0("#", id),
      content = msg
    )
  )
}
