#' Alerts
#'
#' Alerts highlight information for users.
#'
#' @param ... Components to include. Named arguments are passed as HTML
#'   attributes to the parent element.
#'
#' @param class Additional CSS classes for the alert element.
#'
#' @param container An [htmltools::tag] function.
#'
#' @family components
#'
#' @export
#'
#' @examplesIf rlang::is_interactive()
#'
#' alert(
#'   class = "alert-info",
#'   alert_heading("Heads up!"),
#'   "Make sure you know the thing is happening",
#'   htmltools::hr(),
#'   "Use alert classes to change the color of an alert"
#' )
#'
#' alert(
#'   class = "alert-warning",
#'   "Double check those figures.",
#'   alert_button()
#' )
#'
alert <- function(
  ...,
  class = NULL
) {
  component <-
    tags$div(
      class = "alert",
      role = "alert",
      class = class,
      ...
    )

  query <-
    htmltools::tagQuery(component)

  if (query$find(".btn-close")$length() > 0) {
    component <-
      query$addClass("alert-dismissible fade show")$allTags()
  }

  component <-
    dependency_append(component)

  component <-
    s3_class_add(component, "bsides_alert")

  component
}

#' @rdname alert
#' @export
alert_heading <- function(
  ...,
  container = htmltools::h6
) {
  container(
    class = "alert-heading",
    ...
  )
}

#' @rdname alert
#' @export
alert_button <- function() {
  tags$button(
    type = "button",
    class = "btn-close",
    `data-bs-dismiss` = "alert",
    `aria-label` = "Close"
  )
}
