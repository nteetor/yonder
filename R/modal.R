#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs or buttons or simply include text.
#' Create a modal that can by shown or hidden by `toggleModal`. Unlike shiny
#' modals, dull modals must be built ahead of time, but may include dynamically
#' updated components. Modal elements may be included anywhere on a web page.
#'
#' @param header A character vector specifying a title for the modal or a custom
#'   element to use as a header, defaults to `NULL`. The default heading tag is
#'   `h5`.
#'
#' @param body A character vectory specifying the main text of the modal or
#'   custom elements to use as the body of the modal, defaults to `NULL`.
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
#'       buttonInput(id = "toggle", "Click to show modal"),
#'       modal(
#'         id = "simple",
#'         header = "A simple modal",
#'         body = paste(
#'           "Cras mattis consectetur purus sit amet fermentum.",
#'           "Cras justo odio, dapibus ac facilisis in, egestas",
#'           "eget quam. Morbi leo risus, porta ac consectetur",
#'           "ac, vestibulum at eros."
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleModal("simple")
#'       })
#'     }
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       buttonInput(id = "toggle", "Demo login"),
#'       modal(
#'         id = "login",
#'         header = "Please login",
#'         body = tagList(
#'           textInput(
#'             id = "name",
#'             label = "Name",
#'             placeholder = "yourname@@email.com"
#'           ),
#'           passwordInput(
#'             id = "password",
#'             label = "Password"
#'           )
#'         ),
#'         footer = buttonInput(id = "process", "Submit")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleModal("login")
#'       })
#'
#'       observeEvent(input$process, {
#'         print(isolate(input$name))
#'         print(isolate(input$password))
#'       })
#'     }
#'   )
#' }
#'
modal <- function(header = NULL, body = NULL, footer = NULL, ...) {
  tags$div(
    class = "dull-modal modal fade",
    tags$div(
      class = "modal-dialog",
      role = "document",
      tags$div(
        class = "modal-content",
        tags$div(
          class = "modal-header",
          if (is.character(header)) tags$h5(class = "modal-title", header) else
            tagEnsureClass(header, "modal-title"),
          tags$button(
            type = "button",
            class = "close",
            `data-dismiss` = "modal",
            `aria-label` = "Close",
            fontAwesome("times-rectangle")
          )
        ),
        if (!is.null(body)) {
          tags$div(
            class = "modal-body",
            body
          )
        },
        if (!is.null(footer)) {
          tags$div(
            class = "modal-footer",
            footer
          )
        }
      )
    ),
    ...
  )
}

#' @rdname modal
#' @export
toggleModal <- function(id, session = getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    "dull.modal.toggle",
    list(
      id = paste0("#", id)
    )
  )
}
