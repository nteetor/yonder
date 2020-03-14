#' Floats
#'
#' Use `float()` to float an element to the left or right side of its parent
#' element. A newspaper layout is a classic example where an image is floated
#' with text wrapped around.
#'
#' @inheritParams affix
#'
#' @param side A [responsive] argument. One of `"left"` or `"right"` specifying
#'   the side to float the element.
#'
#' @includeRmd man/roxygen/float.Rmd
#'
#' @family design utilities
#' @export
float <- function(x, side) {
  UseMethod("float", x)
}

#' @export
float.yonder_style_pronoun <- function(x, side) {
  NextMethod("float", x)
}

#' @export
float.rlang_box_splice <- function(x, side) {
  NextMethod("float", unbox(x))
}

#' @export
float.shiny.tag <- function(x, side) {
  tag_class_add(x, float_side(side))
}

#' @export
float.default <- function(x, side) {
  tag_class_add(x, float_side(side))
}

float_side <- function(side) {
  side <- resp_construct(side, c("left", "right"))
  resp_classes(side, "float")
}
