#' Modal dialogs
#'
#' Create a modal that can by shown or hidden by `toggleModal`. Modals may be
#' built and included anywhere on the page. Unlike shiny modals, dull modals
#' must be defined ahead of time, but may be dynamically updated during the life
#' cycle of the shiny app by passing, for example, a `textOutput` as part of the
#' modal body.
#'
#' @param header A character vector specifying a title for the modal or custom
#'   tags to use as a header, defaults to `NULL`. When creating a custom header
#'   title elements may need to include the `"modal-title"` HTML class.
#'
#' @param body A character vectory specifying the main text of the modal or
#'   custom tags to use as for the body of the modal, defaults to `NULL`.
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
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = container(
#'       button(id = "toggle", "Click to show modal"),
#'       modal(
#'         id = "hello",
#'         header = "Hello, world!",
#'         body = "A simple modal."
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$toggle, {
#'         toggleModal("hello")
#'       })
#'     }
#'   )
#' }
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
          if (is.character(header)) tags$h5(class = "modal-title", header) else header,
          tags$button(
            type = "button",
            class = "close",
            `data-dismiss` = "modal",
            `aria-label` = "Close",
            icons$fa("times-rectangle")
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

toggleModal <- function(id, session = getDefaultReactiveDomain()) {
  session$sendCustomMessage(
    "dull.modal.toggle",
    list(
      id = paste0("#", id)
    )
  )
}
