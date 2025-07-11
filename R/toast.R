#' Toasts
#'
#' Toasts relay notification-level information to the user.
#'
#' @param ... Components to include inside a toast. Named arguments are added as
#'   HTML attributes to the parent element.
#'
#' @param id A character string. An optional reactive id to track the state of
#'   the toast via `input$<id>`. When visible this value is `"shown"` and when
#'   the toast is dismissed the value is `"hidden"`.
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
#' ui <- page_fluid(
#'   toast_container(
#'     toast()
#'   ),
#'   card(
#'     input_button(
#'       id = "begin",
#'       label = "Show notification"
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$begin, {
#'     showToast(
#'       toast(
#'         list(
#'           span("Notification") %>%
#'             margin(right = "4"),
#'           span(strftime(Sys.time(), "%H:%M")) %>%
#'             margin(right = 1)
#'         ),
#'         "This is notification ", input$show
#'       ) %>%
#'         margin(right = 2, top = 2)
#'     )
#'   })
#' }
#'
#' shinyApp(ui, server)
#'
#'
toast <- function(
  ...,
  id = NULL,
  visibility = c("show", "hide"),
  wrapper = toast_body
) {
  check_string(id, allow_empty = FALSE, allow_null = TRUE)

  visibility <- arg_match(visibility)

  args <- rlang::list2(...)
  attrs <- keep_named(args)
  children <- keep_unnamed(args)

  items <-
    as_toast_items(children, wrapper)

  component <-
    tags$div(
      class = c(
        "toast",
        visibility
      ),
      role = "alert",
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
  attrs <- keep_named(args)

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
    !!!attrs
  )
}

as_toast_items <- function(
  children,
  wrapper
) {
  children <- drop_nulls(children)

  are_items <- vapply(children, is_toast_item, logical(1))

  if (all(are_items)) {
    return(children)
  }

  are_items_rle <- rle(are_items)
  start_indeces <- c(1, head(cumsum(are_items_rle$lengths) + 1, -1))

  children <-
    Map(
      start = start_indeces,
      length = are_items_rle$length,
      already_item = are_items_rle$value,
      function(start, length, already_item) {
        child_subset <- children[start:(start + length - 1)]

        if (already_item) {
          child_subset
        } else {
          list(wrapper(child_subset))
        }
      }
    )

  unlist(children, recursive = FALSE)
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
    `data-bs-dimiss` = "toast",
    `aria-label` = "Close"
  )
}

#' Toast actions
#'
#' Do things with toasts.
#'
#' @param id A string. The id of a [toast_container()].
#'
#' @param toast A [toast()]. A toast component to add to a toast container.
#'   Once added the toast may be shown or hidden.
#'
#' @param target A string. The id of a toast.
#'
#' @param duration A number. The number of seconds to show a toast before
#'   automatically hiding it. If `NULL`, the toast is shown until manually
#'   hidden.
#'
#' @inheritParams input_checkbox_group
#'
#' @describeIn toast_add Add a toast to a toast container.
#'
#' @export
toast_add <- function(
  id,
  toast,
  session = get_current_session()
) {
  msg <-
    drop_nulls(list(
      id = id,
      toast = I(format(toast))
    ))

  session$sendCustomMessage("bsides:toastAdd", msg)
}

#' @describeIn toast_add Show a toast within a toast container.
#'
#' @export
toast_show <- function(
  id,
  target,
  duration = NULL,
  session = get_current_session()
) {
  msg <-
    drop_nulls(list(
      id = id,
      target = target,
      duration = duration
    ))

  session$sendCustomMessage("bsides:toastShow", msg)
}

#' @describeIn toast_add Hide a toast within a toast container.
#'
#' @export
toast_hide <- function(
  id,
  target = NULL,
  session = get_current_session()
) {
  msg <-
    drop_nulls(list(
      id = id,
      target = target
    ))

  session$sendCustomMessage("bsides:toastHide", msg)
}
