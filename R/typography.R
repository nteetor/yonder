#' Dots argument
#'
#' @param ... Any number of child elements passed to the parent element. Named
#'   values are passed as HTML attributes to the parent element.
#'
dots <- function(...) {}


#' Display headings
#'
#' Display headings are not meant to replace the standard HTML heading tags,
#' they are a stand out alternative for eye-catching titles.
#'
#' @inheritParams dots
#'
#' @family components
#' @export
d1 <- function(...) {
  d(1, ...)
}

#' @rdname d1
#' @export
d2 <- function(...) {
  d(2, ...)
}

#' @rdname d1
#' @export
d3 <- function(...) {
  d(3, ...)
}

#' @rdname d1
#' @export
d4 <- function(...) {
  d(4, ...)
}

#' @rdname d1
#' @export
d5 <- function(...) {
  d(5, ...)
}

#' @rdname d1
#' @export
d6 <- function(...) {
  d(6, ...)
}

d <- function(level, ...) {
  heading <-
    tags$h1(
      class = sprintf("display-%s", level),
      ...
    )

  heading <-
    dependency_append(heading)

  heading
}
