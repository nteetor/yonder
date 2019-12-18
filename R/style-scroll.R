#' Vertical and horizontal scroll
#'
#' Many of the applications you build despite a complex layout will still fit
#' onto a single page. To help scroll long content alongside shorter content use
#' the `scroll()` utility function.
#'
#' @param tag A tag element.
#'
#' @param direction One of `"horizontal"` or `"vertical"` specifying which
#'   direction to scroll overflowing content, defaults to `"vertical"`, in which
#'   case the content may croll up and down.
#'
#' @family design utilities
#' @export
scroll <- function(tag, direction = "vertical") {
  assert_possible(direction, c("vertical", "horizontal"))

  direction <- if (direction == "vertical") "scroll-y" else "scroll-x"

  tag_class_add(tag, direction)
}
