#' Display property
#'
#' Use the `display()` utility to adjust how a tag element is rendered. All
#' arguments are responsive allowing you to hide elements on small screens or
#' convert elements from inline to block on large screens.
#'
#' @inheritParams affix
#'
#' @param type A [responsive] argument. One of `"inline"`, `"block"`,
#'   `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`.
#'
#' @family design utilities
#' @export
display <- function(x, type) {
  UseMethod("display", x)
}

#' @export
display.yonder_style_pronoun <- function(x, type) {
  UseMethod("display.yonder_style_pronoun", x)
}

#' @export
display.rlang_box_splice <- function(x, type) {
  UseMethod("display.yonder_style_pronound", unbox(x))
}

#' @export
display.shiny.tag <- function(x, type) {
  tag_class_add(x, display_type(type))
}

#' @export
display.yonder_style_pronoun.default <- function(x, type) {
  style_class_add(x, display_type(type))
}

display_type <- function(type) {
  type <- resp_construct(
    type,
    c("inline", "block", "inline-block", "flex", "inline-flex", "none")
  )

  resp_classes(type, "d")
}
