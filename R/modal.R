#' Modal dialogs
#'
#' Modals are a flexible alert window, which disable interaction with the page
#' behind them. Modals may include inputs or buttons or simply text. To use
#' one or more modals you must first register the modal from the server with
#' `registerModal()`. This will assocaite the modal with an id at which point
#' the rest of your application's server may hide or show the modal with
#' `showModal()` and `hideModal()`, respectively, by referring to this id.
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
#' @param id A character string specifying the id to associate with the modal.
#'
#' @param modal A modal tag element created using `modal()`.
#'
#' @param exprs A list of named values used to interpolate placeholders in a
#'   registered modal, defaults to `list()`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element.
#'
#' @inheritParams updateInput
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
registerModal <- function(id, modal, session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `registerModal()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `registerModal()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:modal", list(
    type = "register",
    data = list(
      id = id,
      content = HTML(as.character(modal)),
      dependencies = processDeps(modal, session)
    )
  ))
}

#' @rdname modal
#' @export
showModal <- function(id, exprs = list(),
                      session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `showModal()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `showModal()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  exprs <- lapply(exprs, as.character)

  if (any(names2(exprs) == "")) {
    stop(
      "invalid `showModal()` argument, `exprs` must be a named list",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:modal", list(
    type = "show",
    data = list(
      id = id,
      exprs = if (length(exprs) > 0) exprs
    )
  ))
}

#' @rdname modal
#' @export
hideModal <- function(id, session = getDefaultReactiveDomain()) {
  if (!is.character(id)) {
    stop(
      "invalid `hideModal()` argument, `id` must be a character string",
      call. = FALSE
    )
  }

  if (is.null(session)) {
    stop(
      "invalid `hideModal()` argument, `session` is NULL",
      call. = FALSE
    )
  }

  session$sendCustomMessage("yonder:modal", list(
    type = "hide",
    data = list(
      id = id
    )
  ))
}
