#' Toasts
#'
#' Toasts relay notification-level information to the user.
#'
#' @inheritParams badge
#'
#' @param id A string. An optional reactive id to track the state of
#'   the toast via `input$<id>`. When visible this value is `"shown"` and when
#'   the toast is dismissed the value is `"hidden"`.
#'
#' @param visibility A string. The default visibility of the toast.
#'
#' @param duration A number. The number of seconds to show the toast for.
#'
#' @param wrapper A [htmltools::tag] function. The function used to wrap the
#'   components passed in `...`.
#'
#' @family components
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' library(shiny)
#' library(bslib)
#'
#' ui <-
#'   page_fluid(
#'     toast_container(
#'       toast(
#'         id = "notify_begin",
#'         duration = 5,
#'         toast_header("Starting task"),
#'         "This task may take a while."
#'       )
#'     ),
#'     card(
#'       input_button(
#'         id = "begin",
#'         text = "Begin task"
#'       )
#'     )
#'   )
#'
#' server <-
#'   function(input, output) {
#'     observeEvent(input$begin, {
#'       toast_show("notify_begin", 2)
#'     })
#'   }
#'
#' shinyApp(ui, server)
#'
#'
toast <- function(
  ...,
  id = NULL,
  visibility = c("hide", "show"),
  duration = NULL,
  wrapper = toast_body
) {
  check_string(id, allow_empty = FALSE, allow_null = TRUE)
  check_number_decimal(duration, min = 0, allow_null = TRUE)

  visibility <- arg_match(visibility)

  args <- rlang::list2(...)
  attrs <- keep_named(args)
  children <- keep_unnamed(args)

  items <-
    as_toast_items(children, wrapper)

  component <-
    tags$div(
      class = c(
        "bsides-toast",
        "toast",
        visibility
      ),
      id = id,
      role = "alert",
      `data-bs-autohide` = if (non_null(duration)) "true" else "false",
      `data-bs-delay` = if (non_null(duration)) duration * 1000,
      `aria-live` = "assertive",
      `aria-atomic` = "true",
      !!!attrs,
      !!!items
    )

  component <-
    dependency_append(component)

  component <-
    s3_class_add(component, c("bsides_toast"))

  component
}

#' @rdname toast
#' @export
toast_container <- function(
  ...,
  position = c("top", "bottom"),
  padding = 3
) {
  if (non_null(position)) {
    position <- arg_match(position)
  }

  args <- rlang::list2(...)

  position <-
    if (non_null(position)) {
      sprintf("%s-0 end-0", position)
    }

  padding <-
    if (non_null(padding)) {
      sprintf("p-%s", padding)
    }

  tags$div(
    class = c(
      "toast-container",
      position,
      padding
    ),
    !!!args
  )
}

as_toast_items <- function(
  children,
  wrapper
) {
  children <- drop_nulls(children)

  wrap_items(
    children,
    is_toast_item,
    wrapper
  )
}

is_toast_item <- function(x) {
  inherits(x, "toast_item")
}

as_toast_item <- function(x) {
  class(x) <- c("toast_item", class(x))
  x
}

#' Toast components
#'
#' Components to include inside a [toast].
#'
#' @returns A `shiny.tag` object.
#'
#' @seealso [toast()] for creating toasts.
#'
#' @export
toast_body <- function(
  ...
) {
  as_toast_item(
    tags$div(
      class = "toast-body",
      ...
    )
  )
}

#' @rdname toast_body
#' @export
toast_header <- function(
  title,
  ...,
  icon = NULL,
  dismiss = toast_button()
) {
  check_string(title, allow_null = TRUE)
  check_string(icon, allow_null = TRUE)

  title <-
    if (non_null(title)) {
      tags$strong(
        class = c(
          if (non_null(icon)) "ms-2",
          "me-auto"
        ),
        title
      )
    }

  as_toast_item(
    tags$div(
      class = "toast-header",
      icon,
      title,
      ...,
      dismiss
    )
  )
}

#' @rdname toast_body
#' @export
toast_button <- function() {
  tags$button(
    type = "button",
    class = "btn-close",
    `data-bs-dismiss` = "toast",
    `aria-label` = "Close"
  )
}

#' Toast actions
#'
#' Do things with toasts.
#'
#' @param id A string. The id of a [toast_container()].
#'
#' @param toast A [toast()]. A toast component to add to a toast container. Once
#'   added, the toast may be shown or hidden.
#'
#' @param target A string. The id of a toast container.
#'
#' @param duration A number. The number of seconds to show a toast before
#'   automatically hiding it. If `NULL`, the toast remains shown until manually
#'   hidden.
#'
#' @inheritParams input_checkbox_group
#'
#' @describeIn toast_add Add a toast to a toast container.
#'
#' @export
toast_add <- function(
  target,
  toast,
  session = get_current_session()
) {
  msg <-
    drop_nulls(list(
      target = target,
      toast = htmltools::doRenderTags(toast)
    ))

  session$sendCustomMessage("bsides:toastAdd", msg)
}

#' @describeIn toast_add Show a toast.
#'
#' @export
toast_show <- function(
  id,
  duration = NULL,
  session = get_current_session()
) {
  check_number_decimal(duration, min = 0, allow_null = TRUE)

  msg <-
    drop_nulls(list(
      method = "show",
      duration = if (non_null(duration)) duration * 1000
    ))

  session$sendInputMessage(id, msg)
}

#' @describeIn toast_add Hide a toast.
#'
#' @export
toast_hide <- function(
  id,
  session = get_current_session()
) {
  msg <-
    drop_nulls(list(
      method = "hide",
    ))

  session$sendInputMessage(id, msg)
}
