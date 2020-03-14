#' Fixed position elements
#'
#' The `affix` utility function applies Bootstrap classes to fix elements to the
#' top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
#' of a page after the element is scrolled past. *Important*, the IE11 and Edge
#' browsers do not support the sticky behavior.
#'
#' @param x A tag element or [.style] pronoun.
#'
#' @param position One of `"top"`, `"bottom"`, or `"sticky"` specifying the
#'   fixed behavior of an element.
#'
#' @include design.R
#' @family design utilities
#' @export
affix <- function(x, position) {
  assert_possible(position, c("top", "bottom", "sticky"))

  UseMethod("affix", x)
}

#' @export
affix.yonder_style_pronoun <- function(x, position) {
  NextMethod("affix", x)
}

#' @export
affix.rlang_box_splice <- function(x, position) {
  NextMethod("affix", unbox(x))
}

#' @export
affix.shiny.tag <- function(x, position) {
  tag_class_add(x, affix_position(position))
}

#' @export
affix.default <- function(x, position) {
  tag_class_add(x, affix_position(position))
}

affix_position <- function(position) {
  if (position == "sticky") {
    "sticky-top"
  } else {
    sprintf("fixed-%s", position)
  }
}
