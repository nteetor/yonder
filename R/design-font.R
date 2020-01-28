#' Font color, size, weight
#'
#' The `font()` utility modifies the color, size, weight, case, or alignment of
#' a tag element's text. All arguments default to `NULL`, in which case they are
#' ignored.  For example, `font(.., size = "lg")` increases font size without
#' affecting color, weight, case, or alignment.
#'
#' @inheritParams affix
#'
#' @eval param_color("text")
#'
#' @param size Deprecated, in future versions of bootstrap resonsive font sizing
#'   will be enabled by default,
#'   \url{https://github.com/twbs/bootstrap/pull/29152}.
#'
#'   One of `"xs"`, `"sm"`, `"base"`, `"lg"`, `"xl"` specifying a font size
#'   relative to the default base page font size, defaults to `NULL`.
#'
#' @param weight One of `"bold"`, `"bolder"`, `"normal"`, `"lighter"`, or
#'   `"light"` specifying the font weight of the element's text, defaults to
#'   `NULL`. `"bolder"` and `"lighter"` change the weight relative to the
#'   current font weight of the element.
#'
#' @param case One of `"upper"`, `"lower"`, or `"title"` specifying a
#'   transformation of the tag element's text, default to `NULL`.
#'
#' @param align A [responsive] argument. One of `"left"`, `"center"`, `"right"`,
#'   or `"justify"`, specifying the alignment of the tag element's text,
#'   defaults to `NULL`.
#'
#' @includeRmd man/roxygen/font.Rmd
#'
#' @family design utilities
#' @export
font <- function(x, color = NULL, size = NULL, weight = NULL, case = NULL,
                 align = NULL) {
  if (!is.null(size)) {
    deprecate_soft("0.2.0", "yonder::font(size = )")
  }

  assert_possible(color, theme_colors)
  assert_possible(weight, c("bold", "bolder", "normal", "lighter", "light"))
  assert_possible(case, c("lower", "upper", "title"))

  UseMethod("font", x)
}

#' @export
font.yonder_style_pronoun <- function(x,  color = NULL, size = NULL,
                                      weight = NULL, case = NULL,
                                      align = NULL) {
  NextMethod("font", x)
}

#' @export
font.rlang_box_splice <- function(x, color = NULL, size = NULL, weight = NULL,
                                  case = NULL, align = NULL) {
  NextMethod("font", unbox(x))
}

#' @export
font.shiny.tag <- function(x, color = NULL, size = NULL, weight = NULL,
                           case = NULL, align = NULL) {
  tag_class_add(x, c(
    font_color(color),
    font_weight(weight),
    font_case(case),
    font_align(align)
  ))
}

#' @export
font.default <- function(x, color = NULL, size = NULL, weight = NULL,
                         case = NULL, align = NULL) {
  tag_class_add(x, c(
    font_color(color),
    font_weight(weight),
    font_case(case),
    font_align(align)
  ))
}

font_color <- function(color) {
  if (is_null(color)) {
    return(NULL)
  }

  sprintf("text-%s", color)
}

font_size <- function(size) {
  if (is_null(size)) {
    return(NULL)
  }

  sprintf("font-size-%s", size)
}

font_weight <- function(weight) {
  if (is_null(weight)) {
    return(NULL)
  }

  sprintf("font-weight-%s", weight)
}

font_case <- function(case) {
  if (is_null(case)) {
    return(NULL)
  }

  if (case == "upper")
    "text-uppercase"
  else if (case == "lower") {
     "text-lowercase"
  } else {
    "text-capitalize"
  }
}

font_align <- function(align) {
  if (is_null(align)) {
    return(NULL)
  }

  align <- resp_construct(align, c("left", "center", "right", "justify"))

  resp_classes(align, "text")
}
