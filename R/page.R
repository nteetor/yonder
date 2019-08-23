#' User interface
#'
#' Every yonder application starts with `webpage()`. This function ensures the
#' necessary resources and dependencies are attached to your user interface and
#' properly lays out an optional navigation bar and main elements.
#'
#' @param ... Any number of tag elements or named values added as children and
#'   attributes to the main section of the page.
#'
#' @param nav A navigation element, typically a call to [navbar()], added at the
#'   top of the page, defaults to `NULL`.
#'
#' @family layout functions
#' @export
#' @examples
#'
#' webpage(
#'   p("Pretty simple")
#' )
#'
#' webpage(
#'   nav = navbar(),
#'   container(
#'     columns(
#'       column(),
#'       column()
#'     )
#'   )
#' )
#'
webpage <- function(..., nav = NULL) {
  args <- list(...)

  if (is.null(args$role)) {
    args$role <- "main"
  }

  attach_dependencies(
    tags$body(
      tags$header(
        nav
      ),
      tag("main", args)
    )
  )
}
