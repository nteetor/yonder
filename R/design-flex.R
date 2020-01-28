#' Understanding responsive arguments
#'
#' @description
#'
#' A responsive argument may be a single value or a named list. Possible names
#' includes `default` or `xs`, `sm`, `md`, `lg`, and `xl`. Specifying a single
#' unnamed value is equivalent to specifying `default` or `xs`. The possible
#' values will be described in the specific help page. Most responsive arguments
#' will default to `NULL` in which case no corresponding style is applied.
#'
#' Responsive arguments allow you to apply styles to tag elements based on the
#' size of the viewport. This is important when developing applications for both
#' web and mobile.  Specifying a single unnamed value the style will be applied
#' for all viewport sizes. Use the names above to apply a style for viewports of
#' that size and larger. For example, specifying `list(default = x, md = y)`
#' will apply `x` on extra small and small viewports, but for medium, large, and
#' extra large viewports `y` is applied.
#'
#' Styles for larger viewports take precedence. See below for details about each
#' breakpoint.
#'
#' **extra small**
#'
#' How: pass a single value, use name `xs`, or use name `default`.
#'
#' When: the style is always applied, unless supplanted by a style for any other
#' viewport size.
#'
#' **small**
#'
#' How: use name `sm`.
#'
#' When: the style is applied when the viewport is at least 576px wide, think
#' landscape phones.
#'
#' **medium**
#'
#' How: use name `md`.
#'
#' When: the style is applied when the viewport is at least 768px wide, think
#' tablets.
#'
#' **large**
#'
#' How: use name `lg`.
#'
#' When: the style is applied when the viewport is at least 992px wide, think
#' laptop or smaller desktops.
#'
#' **extra large**
#'
#' How: use name `xl`.
#'
#' When: the style is applied when the viewport is at least 1200px wide, think
#' large desktops.
#'
#' @name responsive
NULL

#' Flex layout
#'
#' Use `flex()` to control how a flex container tag element places its flex
#' items or child tag elements. For more on turning a tag element into a flex
#' container see [display()]. By default tag elements within a flex container
#' are treated as flex items.
#'
#' @inheritParams affix
#'
#' @param direction A [responsive] argument. One of `"row"` or `"column"`
#'   specifying the placement of flex items, defaults to `NULL`. If `"row"`
#'   items are placed vertically, if `"column"` items are placed horizontally.
#'   Browsers place items vertically by default.
#'
#' @param reverse A [responsive] argument. One of `TRUE` or `FALSE` specifying
#'   if flex items are placed in reverse order, defaults to `NULL`. If `TRUE`
#'   items are placed from right to left when `direction` is `"row"` or bottom
#'   to top when `direction` is `"column"`.
#'
#' @param justify A [responsive] argument. One of `"start"`, `"end"`,
#'   `"center"`, `"between"`, or `"around"` specifying how items are
#'   horizontally aligned, defaults to `NULL`. See the **justify** section below
#'   for more on how the different values affect horizontal spacing.
#'
#' @param align A [responsive] argument. One of `"start"`, `"end"`, `"center"`,
#'   `"baseline"`, or `"stretch"` specifying how items are vertically aligned,
#'   defaults to `NULL`. See the **align** section below for more on how the
#'   different values affect vertical spacing.
#'
#' @param wrap A [responsive] argument. One of `TRUE` or `FALSE` specifying
#'   whether to wrap flex items inside the flex container, `tag`, defaults to
#'   `NULL`. If `TRUE` items wrap inside the container, if `FALSE` items will
#'   not wrap. See the **wrap** section below for more.
#'
#' @includeRmd man/roxygen/flex.Rmd
#'
#' @family design utilities
#' @export
flex <- function(x, direction = NULL, justify = NULL, align = NULL,
                 wrap = NULL, reverse = NULL) {
  UseMethod("flex", x)
}

#' @export
flex.yonder_style_pronoun <- function(x, direction = NULL, justify = NULL,
                                      align = NULL, wrap = NULL,
                                      reverse = NULL) {
  NextMethod("flex", x)
}

#' @export
flex.rlang_box_splice <- function(x, direction = NULL, justify = NULL,
                                  align = NULL, wrap = NULL, reverse = NULL) {
  NextMethod("flex", unbox(x))
}

#' @export
flex.shiny.tag <- function(x, direction = NULL, justify = NULL, align = NULL,
                           wrap = NULL, reverse = NULL) {
  tag_class_add(x, c(
    flex_direction(direction, reverse),
    flex_justify(justify),
    flex_align(align),
    flex_wrap(wrap)
  ))
}

#' @export
flex.default <- function(x, direction = NULL, justify = NULL, align = NULL,
                         wrap = NULL, reverse = NULL) {
  tag_class_add(x, c(
    flex_direction(direction, reverse),
    flex_justify(justify),
    flex_align(align),
    flex_wrap(wrap)
  ))
}

flex_direction <- function(direction, reverse) {
  direction <- resp_construct(direction, c("row", "column"))

  if (!is.null(names(reverse))) {
    direction[names2(reverse)] <- lapply(names2(reverse), function(n) {
      # This is necessary because "row" may be implied and not explicitly
      # passed in `direction`
      prev <- direction[[n]] %||% "row"

      if (reverse[[n]]) {
        sprintf("%s-reverse", prev)
      } else {
        prev
      }
    })
  }

  resp_classes(direction, "flex")
}

flex_justify <- function(justify) {
  j <- resp_construct(justify, c("start", "end", "center", "between", "around"))

  resp_classes(j, "justify-content")
}

flex_align <- function(align) {
  a <- resp_construct(align, c("start", "end", "center", "baseline", "stretch"))

  resp_classes(a, "align-items")
}

flex_wrap <- function(wrap) {
  w <- resp_construct(wrap, c(TRUE, FALSE))

  if (length(w)) {
    w <- lapply(w, function(w) if (w) "wrap" else "nowrap")
  }

  resp_classes(w, "flex")
}
