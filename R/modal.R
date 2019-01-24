#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs or buttons or simply text.
#'
#' @param title A character string or tag element specifying the title of the
#'   modal.
#'
#' @param body A character string or tag element specifying the body of the modal.
#'
#' @param footer A character string or tag element specifying the footer of the
#'   modal.
#'
#' @param center One of `TRUE` or `FALSE` specifying whether the modal is
#'   vertically centered on the page, defaults to `FALSE`.
#'
#' @param size One of `"small"`, `"large"`, or `"xl"` (extra large) specifying
#'   whether to shrink or grow the width of the modal, defaults to `NULL`, in
#'   which case the width is not adjusted.
#'
#' @param modal A modal tag element created using `modal()`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
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
#'   observeEvent(input$trigger, ignoreInit = TRUE, {
#'     showModal(
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
#'   })
#' }
#'
#' shinyApp(ui, server)
#' ```
#'
#' @family content
#' @export
#' @examples
#'
#' ### Simple modal
#'
#' modal(
#'   title = "Title",
#'   body = "Cras placerat accumsan nulla.",
#'   footer = buttonInput(
#'     id = "closeModal",
#'     label = "Close"
#'   ) %>%
#'     background("blue")
#' )
#'
#' ### Modal with container body
#'
#' modal(
#'   size = "large",
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
modal <- function(title = NULL, body = NULL, footer = NULL, ..., center = FALSE,
                  size = NULL) {
  if (!is.null(size) && !re(size, "small|large|xl")) {
    stop(
      "invalid `modal()` argument, `size` must be one of ",
      '"small", "large", or "xl"',
      call. = FALSE
    )
  }

  title <- if (!is.null(title)) {
    tagAddClass(
      if (!is_tag(title)) tags$h5(title) else title,
      "modal-title"
    )
  }

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

  body <- tags$div(
    class = "modal-body",
    body
  )

  footer <- if (!is.null(footer)) {
    tags$div(
      class = "modal-footer",
      footer
    )
  }

  tags$div(
    class = collate(
      "modal-dialog",
      if (center) "modal-dialog-centered",
      if (!is.null(size)) {
        paste0(
          "modal-",
          if (size == "small") "sm" else if (size == "large") "lg" else size
        )
      }
    ),
    role = "document",
    tags$div(
      class = "modal-content",
      header,
      body,
      if (!is.null(footer)) footer
    )
  )
}

#' @rdname modal
#' @export
showModal <- function(modal, session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid `showModal()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:modal", list(
    type = "show",
    data = list(
      content = HTML(as.character(modal)),
      dependencies = processDeps(modal, session)
    )
  ))
}

#' @rdname modal
#' @export
closeModal <- function(session = getDefaultReactiveDomain()) {
  if (is.null(session)) {
    stop(
      "invalid `closeModal()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:modal", list(
    type = "close",
    data = list()
  ))
}
