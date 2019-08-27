#' User interface
#'
#' Begin creating a user interface. The `webpage()` function properly lays out a
#' navigation bar and main section of elements.
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
  dep_attach({
    args <- list(...)

    if (is.null(args$role)) {
      args$role <- "main"
    }

    tags$body(
      tags$header(
        nav
      ),
      htmltools::tag("main", args)
    )
  })
}
