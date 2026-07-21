#' Alerts
#'
#' Alerts highlight information for users.
#'
#' @param ... Components to include. Named arguments are passed as HTML
#'   attributes to the parent element.
#'
#' @param type Optional semantic type.
#'
#' @param dismiss The method for removing the alert. One of `"animate"`,
#' `"instant"`, or `"none"`.
#'
#' @param dismiss_button The dismiss button element. A [htmltools::tag] object.
#'
#' @param container An [htmltools::tag] function.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family components
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' alert(
#'   type = "info",
#'   dismiss = "none",
#'   alert_heading("Heads up!"),
#'   "Make sure you know the thing is happening",
#'   htmltools::hr(),
#'   "Use alert classes to change the color of an alert"
#' )
#'
#' alert(
#'   type = "warning",
#'   "Double check those figures."
#' )
#'
alert <-
  function(
    ...,
    type = NULL,
    dismiss = c("animate", "instant", "none"),
    dismiss_button = alert_button()
  ) {
    if (!is.null(type)) {
      type <-
        arg_match(
          type,
          c(
            "primary",
            "secondary",
            "success",
            "info",
            "warning",
            "danger",
            "light",
            "dark"
          )
        )
    }
    dismiss <- arg_match(dismiss)

    component <-
      tags$div(
        class = "alert",
        class = sprintf("alert-%s", type),
        class = switch(
          dismiss,
          animate = "alert-dismissible fade show",
          instant = "alert-dismissible",
          none = NULL
        ),
        role = "alert",
        ...,
        if (dismiss != "none") dismiss_button
      )

    component <-
      dependency_append(component)

    component <-
      s3_class_add(component, "bsides_alert")

    component
  }

#' @rdname alert
#' @export
alert_heading <-
  function(
    ...,
    container = htmltools::h5
  ) {
    container(
      class = "alert-heading",
      ...
    )
  }

#' @rdname alert
#' @export
alert_button <-
  function() {
    tags$button(
      type = "button",
      class = "btn-close",
      `data-bs-dismiss` = "alert",
      `aria-label` = "Close"
    )
  }
