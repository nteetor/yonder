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
#' @param ... Unnamed values passed as tag elements to the body of the modal.
#'   or named values passed as HTML attributes to the body element of the
#'   modal.
#'
#' @param header A character string or tag element specifying the header of the
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
#'   id = "simple",
#'   header = h5("Title"),
#'   p("Cras placerat accumsan nulla.")
#' )
#'
#' ### Modal with container body
#'
#' modal(
#'   id = "more_complex",
#'   size = "lg",
#'   header = h5("More complex"),
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
modal <- function(id, ..., header = NULL, footer = NULL, center = FALSE,
                  size = "md", fade = TRUE) {
  assert_id()
  assert_possible(size, c("sm", "md", "lg", "xl"))

  dep_attach({
    args <- list(...)

    if (!is.null(header)) {
      formatted_tags <- list(
        h1 = function(...) tags$h1(class = "modal-title", ...),
        h2 = function(...) tags$h2(class = "modal-title", ...),
        h3 = function(...) tags$h3(class = "modal-title", ...),
        h4 = function(...) tags$h4(class = "modal-title", ...),
        h5 = function(...) tags$h5(class = "modal-title", ...),
        h6 = function(...) tags$h6(class = "modal-title", ...)
      )

      header <- eval(
        substitute(header),
        envir = list2env(formatted_tags, envir = parent.frame())
      )
    }

    header <- tags$div(
      class = "modal-header",
      header,
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

    content <- tags$div(
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

    tags$div(
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
  })
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
