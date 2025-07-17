#' Modal dialogs
#'
#' Modals are flexible alert windows, which disable interaction with the page
#' behind them. Modals may include inputs, buttons, or simply text.
#'
#' @inheritParams badge
#'
#' @param id A string. The id of a modal. Use `input$<id>` to query the state of
#'   the modal.
#'
#' @param position A string. The position of the modal on the screen.
#'
#' @param size A string. The size of the modal.
#'
#' @param modal A modal tag element created using `modal()`.
#'
#' @inherit badge return
#'
#' @describeIn modal_dialog Construct a modal.
#'
#' @family components
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' modal_dialog(
#'   id = "example1",
#'   modal_header(modal_title("Example 1")),
#'   "Our first modal example.",
#'   "It's simple, but it gets the job done.",
#'   modal_footer()
#' )
#'
modal_dialog <- function(
  id,
  ...,
  position = c("top", "center"),
  size = c("md", "sm", "lg", "xl", "fullscreen"),
  scroll = c("modal", "body"),
  backdrop = c("default", "static", "none"),
  wrapper = modal_body
) {
  check_string(id, allow_null = TRUE)

  position <- arg_match(position)
  size <- arg_match(size)
  scroll <- arg_match(scroll)
  backdrop <- arg_match(backdrop)

  args <- rlang::list2(...)
  attrs <- keep_named(args)
  children <- as_modal_items(keep_unnamed(args), wrapper)

  backdrop <-
    switch(
      backdrop,
      default = "true",
      none = "false",
      static = "static"
    )

  component <-
    tags$div(
      class = "bsides-modal modal fade",
      id = id,
      tabindex = "-1",
      `aria-hidden` = "true",
      `data-bs-backdrop` = backdrop,
      !!!attrs,
      tags$div(
        class = c(
          "modal-dialog",
          sprintf("modal-%s", size),
          if (position == "center") "modal-dialog-centered",
          if (scroll == "body") "modal-dialog-scrollable"
        ),
        tags$div(
          class = "modal-content",
          !!!children
        )
      )
    )

  component <-
    dependency_append(component)

  component <-
    s3_class_add(component, "bsides_modal")

  component
}

#' @describeIn modal_dialog Open a modal.
#'
#' @export
modal_toggle <- function(
  id,
  text,
  ...
) {
  check_string(id)

  tags$button(
    type = "button",
    class = "btn btn-primary",
    `data-bs-toggle` = "modal",
    `data-bs-target` = sprintf("#%s", id),
    text,
    ...
  )
}

is_modal <- function(x) {
  inherits(x, "bsides_modal")
}

is_modal_item <- function(x) {
  inherits(x, "modal_item")
}

as_modal_item <- function(x) {
  class(x) <- c("modal_item", class(x))
  x
}

as_modal_items <- function(
  children,
  wrapper
) {
  children <- drop_nulls(children)

  wrap_items(
    children,
    is_modal_item,
    wrapper
  )
}

#' Modal items
#'
#' Components of a modal dialog.
#'
#' @describeIn modal_body The main content of a modal.
#'
#' @export
modal_body <- function(
  ...
) {
  as_modal_item(
    tags$div(
      class = "modal-body",
      ...
    )
  )
}

#' @describeIn modal_body A title suitable for use in modal dialog.
#'
#' @export
modal_title <- function(
  ...
) {
  tags$h1(
    class = "modal-title fs-5",
    ...
  )
}

#' @describeIn modal_body Add a header to a modal dialog.
#'
#' @export
modal_header <- function(
  ...,
  close = modal_close()
) {
  as_modal_item(
    tags$div(
      class = "modal-header",
      ...,
      close
    )
  )
}

#' @describeIn modal_body A button without text used to close a modal dialog,
#'   typically found in the modal header.
#'
#' @export
modal_close <- function() {
  tags$button(
    type = "button",
    class = "btn-close align-self-auto",
    `data-bs-dismiss` = "modal",
    `aria-label` = "Close"
  )
}

#' @describeIn modal_body Add a footer to a modal dialog.
#'
#' @export
modal_footer <- function(
  ...,
  close = modal_dismiss()
) {
  as_modal_item(
    tags$div(
      class = "modal-footer",
      ...,
      close
    )
  )
}

#' @describeIn modal_body A button with text used to close a modal dialog,
#'   typically found the modal footer.
#'
#' @export
modal_dismiss <- function(
  ...,
  text = "Close"
) {
  tags$button(
    type = "button",
    class = "btn btn-primary",
    `data-bs-dismiss` = "modal",
    `aria-label` = text,
    text
  )
}

#' Modal server functions
#'
#' Modal server functions.
#'
#' @param modal A [modal_dialog] or string. A new modal to show or the id of an
#'   existing modal.
#'
#' @inheritParams update_checkbox
#'
#' @export
modal_show <- function(
  modal,
  session = get_current_session()
) {
  if (is_tag(modal)) {
    modal <-
      dependency_process(modal, session)
  }

  msg <-
    list(
      modal = modal
    )

  session$sendCustomMessage("bsides:modalShow", msg)
}

#' @rdname modal_show
#'
#' @export
modal_hide <- function(
  session = get_current_session()
) {
  session$sendCustomMessage("bsides:modalClose", list())
}
