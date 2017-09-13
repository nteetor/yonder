#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs or buttons or simply include text.
#' Create a modal that can by shown or hidden by `toggleModal`. Unlike shiny
#' modals, dull modals must be built ahead of time, but may include dynamically
#' updated components. Modal elements may be included anywhere on a web page.
#'
#' @param title A character string specifying the modal's title.
#'
#' @param body A character string specifying the body of the modal or
#'   custom element to use as the body of the modal, defaults to `NULL`.
#'
#' @param footer Custom tags to include at the bottom of the modal, defaults to
#'   `NULL`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       buttonInput(id = "button", "Click to show modal")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$button, {
#'         sendModal(
#'           title = "A simple modal",
#'           body = paste(
#'             "Cras mattis consectetur purus sit amet fermentum.",
#'             "Cras justo odio, dapibus ac facilisis in, egestas",
#'             "eget quam. Morbi leo risus, porta ac consectetur",
#'             "ac, vestibulum at eros."
#'           )
#'         )
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         class = "justify-content-center",
#'         col(
#'           class = "col-auto",
#'           buttonInput(id = "trigger", "Trigger modal")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$trigger, {
#'         sendModal(
#'           title = "Login",
#'           body = loginInput("login")
#'         )
#'       })
#'
#'       observeEvent(input$login, {
#'         if (input$login$username != "" && input$login$password != "") {
#'           closeModal()
#'         }
#'       })
#'     }
#'   )
#' }
#'
sendModal <- function(title, body, footer = NULL,
                      session = getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    "dull:modal",
    list(
      title = htmltools::HTML(as.character(title)),
      body = htmltools::HTML(as.character(body)),
      footer = if (!is.null(footer)) htmltools::HTML(as.character(footer))
    )
  )
}

#' @rdname sendModal
#' @export
closeModal <- function(session = getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    "dull:modal",
    list(
      close = TRUE
    )
  )
}
