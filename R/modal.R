#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs, buttons, or simply text. Each modal
#' may be assigned an `id`. By default `hideModal()` will hide all modals, but
#' you may instead specify a modal's `id` in which case only that modal is
#' closed. Additionally, when `id` is not `NULL` observers and reactives may
#' watch for the modal's close event.
#'
#' @param id A character string specifying the id of the modal, when closed
#'   `input[[id]]` is set to `TRUE`.
#'
#' @param title A character string or tag element specifying the title of the
#'   modal.
#'
#' @param ... Unnamed values passed as tag elements to the body of the modal.
#'   or named values passed as HTML attributes to the body element of the
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
#'     id = "open",
#'     "Open modal",
#'     icon("plus")
#'   )
#' )
#'
#' server <- function(input, output) {
#'   modal1 <- modal(
#'     title = "A simple modal",
#'     p(
#'       "Cras mattis consectetur purus sit amet fermentum.",
#'       "Cras justo odio, dapibus ac facilisis in, egestas",
#'       "eget quam. Morbi leo risus, porta ac consectetur",
#'       "ac, vestibulum at eros."
#'     )
#'   )
#'
#'   observeEvent(input$open, ignoreInit = TRUE, {
#'     showModal(modal1)
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
#'   p("Cras placerat accumsan nulla.")
#' )
#'
#' ### Modal with container body
#'
#' modal(
#'   id = NULL,
#'   size = "lg",
#'   title = "More complex",
#'   container(
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

  if (missing(title)) {
    stop(
      "invalid argument in `modal()`, please specify `title`",
      call. = FALSE
    )
  }

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

  if (!is.null(footer)) {
    footer <- tags$div(
      class = "modal-footer",
      footer
    )
  }

  content <-tags$div(
    class = "modal-content",
    header,
    tag_attributes_add(
      tags$div(
        class = "modal-body",
        unnamed_values(args)
      ),
      named_values(args)
    ),
    footer
  )

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
      content
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
