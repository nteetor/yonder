#' Vertical and horizontal scroll
#'
#' Many of the applications you build despite a complex layout will still fit
#' onto a single page. To help scroll long content alongside shorter content use
#' the `scroll()` utility function.
#'
#' @inheritParams affix
#'
#' @param direction One of `"horizontal"` or `"vertical"` specifying which
#'   direction to scroll overflowing content, defaults to `"vertical"`, in which
#'   case the content may scroll up and down.
#'
#' @family design utilities
#' @export
scroll <- function(x, direction = "vertical") {
  assert_possible(direction, c("vertical", "horizontal"))

  UseMethod("scroll", x)
}

#' @export
scroll.yonder_style_pronoun <- function(x, direction = "vertical") {
  NextMethod("scroll", x)
}

#' @export
scroll.rlang_box_splice <- function(x, direction = "vertical") {
  NextMethod("scroll", unbox(x))
}

#' @export
scroll.shiny.tag <- function(x, direction = "vertical") {
  tag_class_add(x, scroll_direction(direction))
}

#' @export
scroll.default <- function(x, direction = "vertical") {
  tag_class_add(x, scroll_direction(direction))
}

scroll_direction <- function(direction) {
  if (direction == "vertical") {
    "scroll-y"
  } else {
    "scroll-x"
  }
}
