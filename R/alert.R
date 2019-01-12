#' Alert boxes
#'
#' Use an alert element to let the user know of successes or to call attention
#' to problems.
#'
#' @param ... Character strings specifying the text of the alert or additional
#'   named arguments passed as HTML attributes to the alert element.
#'
#' @param title A character string or tag element specifying a heading for the
#'  alert, defaults to `NULL`, in which case a title is not added.
#'
#' @family content
#' @export
#' @examples
#'
#' ### Default alert
#'
#' alert("Donec at pede.")
#'
#' ### A more complex alert
#'
#' alert(
#'   p("Etiam vel tortor sodales"),
#'   hr(),
#'   p("Fusce commodo.")
#' ) %>%
#'   background("amber")
#'
alert <- function(..., title = NULL) {
  title <- if (!is.null(title) && !is_tag(title)) {
    tags$h4(class = "alert-heading", title)
  } else {
    title
  }

  attachDependencies(
    tags$div(
      class = "alert alert-grey fade show",
      role = "alert",
      title,
      ...
    ),
    yonderDep()
  )
}
