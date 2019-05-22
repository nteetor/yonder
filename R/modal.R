#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs or buttons or simply text. To use
#' one or more modals you must first register the modal from the server with
#' `registerModal()`. This will assocaite the modal with an id at which point
#' the rest of your application's server may hide or show the modal with
#' `showModal()` and `hideModal()`, respectively, by referring to this id.
#'
#' @param id A character string specifying the id of the modal, when closed
#'   `input[[id]]` is set to `TRUE`.
#'
#' @param title A character string or tag element specifying the title of the
#'   modal.
#'
#' @param ... Unnamed arguments passed as tag elements to the body of the modal
#'   or named arguments passed as HTML attributes to the body element of the
#'   modal.
#'
#' @param footer A character string or tag element specifying the footer of the
#'   modal.
#'
#' @param center One of `TRUE` or `FALSE` specifying whether the modal is
#'   vertically centered on the page, defaults to `FALSE`.
#'
#' @param size One of `"sm"` (small), `"md"` (medium), `"lg"` (large), or `"xl"`
#'   (extra large) specifying the relative width of the modal, defaults to
#'   `"md"`.
#'
#' @param fade One of `TRUE` or `FALSE` specifying if the modal fades in when
#'   shown and fades out when closed, defaults to `TRUE`.
#'
#' @param modal A modal tag element created using `modal()`.
#'
#' @inheritParams collapsePane
#'
#' @section Example application:
#'
#' ```R
#' ui <- container(
#'   buttonInput(
#'     id = "trigger",
#'     "Open modal",
#'     icon("plus")
#'   )
#' )
#'
#' server <- function(input, output) {
#'   isolate(
#'     registerModal(
#'       id = "modal1",
#'       modal(
#'         title = "A simple modal",
#'         body = paste(
#'           "Cras mattis consectetur purus sit amet fermentum.",
#'           "Cras justo odio, dapibus ac facilisis in, egestas",
#'           "eget quam. Morbi leo risus, porta ac consectetur",
#'           "ac, vestibulum at eros."
#'         )
#'       )
#'     )
#'   )
#'
#'   observeEvent(input$trigger, ignoreInit = TRUE, {
#'     showModal("modal1")
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family components
#' @export
#' @examples
#'
#' ### Simple modal
#'
#' modal(
#'   id = NULL,
#'   title = "Title",
#'   body = "Cras placerat accumsan nulla."
#' )
#'
#' ### Modal with container body
#'
#' modal(
#'   id = NULL,
#'   size = "lg",
#'   title = "More complex",
#'   body = container(
#'     columns(
#'       column("Cras placerat accumsan nulla."),
#'       column("Curabitur lacinia pulvinar nibh."),
#'       column(
#'         "Aliquam posuere.",
#'         "Praesent fermentum tempor tellus."
#'       )
#'     )
#'   )
#' )
#'
modal <- function(id, title, ..., footer = NULL, center = FALSE, size = "md",
                  fade = TRUE) {
  assert_id()
  assert_possible(size, c("sm", "md", "lg", "xl"))

  args <- list(...)

  title <- tag_class_add(
    if (!is_tag(title)) tags$h5(title) else title,
    "modal-title"
  )

  header <- tags$div(
    class = "modal-header",
    title,
    tags$button(
      type = "button",
      class = "close",
      `data-dismiss` = "modal",
      `aria-label` = "Close",
      tags$span(
        `aria-hidden` = "true",
        HTML("&times;")
      )
    )
  )

  body <- tags$div(class = "modal-body", unnamed_values(args))

  footer <- if (!is.null(footer)) {
    tags$div(
      class = "modal-footer",
      footer
    )
  }

  component <- tags$div(
    class = str_collate(
      "yonder-modal modal",
      if (fade) "fade"
    ),
    id = id,
    tabindex = "-1",
    role = "dialog",
    tags$div(
      class = str_collate(
        "modal-dialog",
        if (center) "modal-dialog-centered",
        if (!is.null(size) && size != "md") paste0("modal-", size)
      ),
      role = "document",
      tags$div(
        class = "modal-content",
        named_values(args),
        header,
        body,
        if (!is.null(footer)) footer
      )
    )
  )

  component
}

#' @rdname modal
#' @export
showModal <- function(modal, session = getDefaultReactiveDomain()) {
  assert_session()

  id <- modal$attribs$id

  session$sendCustomMessage("yonder:modal", list(
    type = "show",
    data = list(
      id = id,
      content = HTML(as.character(modal)),
      dependencies = processDeps(modal, session)
    )
  ))
}

#' @rdname modal
#' @export
closeModal <- function(id = NULL, session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  session$sendCustomMessage("yonder:modal", list(
    type = "close",
    data = list(
      id = id
    )
  ))
}
