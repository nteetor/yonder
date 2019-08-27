#' Toasts
#'
#' Send notifications to the user. Create notification elements, toasts, with
#' the `toast()` function. Display toasts with `showToast()` and remove all
#' active toasts with `closeToast()`.
#'
#' @param ... Any number of character strings or tag elements to include in the
#'   body of the toast.
#'
#'   Any number of named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @param header A character string or tag element specifying a header for the
#'   toast, defaults to `NULL`. A close button is always included in the
#'   header.
#'
#' @param toast A toast element, typically built with `toast()`.
#'
#' @param duration A positive integer or `NULL` specifying the duration of the
#'   toast in seconds by default a toast is removed after 4 seconds. If `NULL`
#'   the toast is not automatically removed.
#'
#' @param action A character string specifying a reactive id. If specified, the
#'   hiding or closing of the toast will set the reactive id `action` to `TRUE`.
#'
#' @inheritParams collapsePane
#'
#' @section Showing notifications:
#'
#' ```R
#' ui <- container(
#'   buttonInput(
#'     id = "show",
#'     label = "Show notification"
#'   ) %>%
#'     margin(3)
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$show, {
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
#' ```
#'
#' @section Reacting to notifications:
#'
#' When a notification is not automatically closed you may want to know
#' when the notification is manually closed.
#'
#' ```R
#' ui <- container(
#'   buttonInput(
#'     id = "show",
#'     label = "Show notification"
#'   ) %>%
#'     margin(3)
#' )
#'
#' server <- function(input, output) {
#'   observeEvent(input$show, {
#'     showToast(
#'       action = "undo",
#'       duration = NULL,
#'       toast(
#'         tags$strong("Close") %>%
#'           margin(right = "auto"),
#'         "When closing this notification, see the console"
#'       ) %>%
#'         margin(right = 2, top = 2)
#'     )
#'   })
#'
#'   observeEvent(input$undo, {
#'     print("The notification was closed")
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
#' ### A simple toast
#'
#' # The `"fade"` and `"show"` classes have been added for the sake of
#' # these examples.
#'
#' toast(
#'   class = "fade show",
#'   header = div("Header") %>%
#'     margin(right = "auto"),
#'   "Hello, world!"
#' )
#'
#' ### Styling pieces of a toast
#'
#' toast(
#'   class = "fade show",
#'   list(
#'     div("Notification") %>%
#'       font(weight = "bold") %>%
#'       margin(right = "auto"),
#'     tags$small("1 min ago")
#'   ),
#'   "Hello, world!"
#' )
#'
toast <- function(header, ...) {
  dep_attach({
    args <- list(...)

    header <- tags$div(
      class = "toast-header",
      list(
        header,
        tags$button(
          type = "button",
          class = "ml-auto close",
          `data-dismiss` = "toast",
          `aria-label` = "Close",
          tags$span(
            `aria-hidden` = "true",
            HTML("&times;")
          )
        )
      )
    )

    component <- tags$div(
      class = "toast",
      role = "alert",
      `aria-live` = "polite",
      `aria-atomic` = "true",
      header,
      tags$div(
        class = "toast-body",
        unnamed_values(args)
      )
    )

    tag_attributes_add(component, named_values(args))
  })
}

#' @rdname toast
#' @export
showToast <- function(toast, duration = 4, action = NULL,
                      session = getDefaultReactiveDomain()) {
  assert_session()
  assert_duration()

  if (!is_tag(toast)) {
    stop(
      "invalid argument in `showToast()`, `toast` must be a tag element",
      call. = FALSE
    )
  }

  if (is.null(duration)) {
    toast[["attribs"]][["data-autohide"]] <- "false"
  } else {
    toast[["attribs"]][["data-delay"]] <- duration * 1000
  }

  toast[["attribs"]][["data-action"]] <- action

  content <- coerce_content(toast)

  session$sendCustomMessage("yonder:toast", list(
    type = "show",
    data = list(
      content = content
    )
  ))
}

#' @rdname toast
#' @export
closeToast <- function(session = getDefaultReactiveDomain()) {
  assert_session()

  session$sendCustomMessage("yonder:toast", list(
    type = "close",
    data = list()
  ))
}
