#' Responsive arguments
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
#' Styles for larger viewports take precedance. See below for details about each
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
#' @param tag A tag element.
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
#' @param align A [responsive] argument. One of `"start"`, `"end"`, `"center'`,
#'   `"baseline"`, or `"stretch"` specifying how items are vertically aligned,
#'   defaults to `NULL`. See the **align** section below for more on how the
#'   different values affect vertical spacing.
#'
#' @param wrap A [responsive] argument. One of `TRUE` or `FALSE` specifying
#'   whether to wrap flex items inside the flex containter, `tag`, defaults
#'   to `NULL`. If `TRUE` items wrap inside the container, if `FALSE` items will
#'   not wrap. See the **wrap** section below for more.
#'
#'
#' @section `direction`:
#'
#' Because horizontal placement the browser default you may not often use
#' `flex(.., direction = "row")`.  The responsive arguments are potentially more
#' useful as shown in the following example. On small screens the flex items are
#' placed vertically and can occupy the full width of the mobile device. On
#' medium or larger screens the items are placed horizontally once again.
#'
#' ```
#' div(
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border()
#' ) %>%
#'   display(flex = TRUE) %>%
#'   flex(
#'     direction = list(xs = "column", md = "row")
#'   ) %>%
#'   background("grey") %>%
#'   border()
#' ```
#'
#' Here is a simpler example of a flex container with its children placed into
#' columns.
#'
#' ```
#' div(
#'   div("A flex item") %>%
#'     padding(3) %>%
#'     border(),
#'    div("A flex item") %>%
#'     padding(3) %>%
#'      border(),
#'     div("A flex item") %>%
#'     padding(3) %>%
#'       border()
#' ) %>%
#'   display(flex = TRUE) %>%
#'   flex(direction = "column")
#' ```
#'
#' @section `justify`:
#'
#' Below you can see how the possible `justify` values change the horizontal
#' spacing of items within a flex container element.
#'
#' `"start"`
#'
#' `| Item 1 | Item 2 | Item 3 | ================= |`
#'
#' `"end"`
#'
#' `| ================= | Item 1 | Item 2 | Item 3 |`
#'
#' `"center"`
#'
#' `| ======= | Item 1 | Item 2 | Item 3 | ======= |`
#'
#' `"between"`
#'
#' `| Item 1 | ======= | Item 2 | ======= | Item 3 |`
#'
#' `"around"`
#'
#' `| == | Item 1 | == | Item 2 | == | Item 3 | == |`
#'
#' @section `align`:
#'
#' Below you can see how the possible `align` values change the vertial spacing
#' of items within a flex container element.
#'
#' **`"start"`**
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | ================== |
#' |        |        |        |                    |
#' |        |        |        |                    |
#' ```
#'
#' **`"end"`**,
#'
#' ```
#' |        |        |        |                    |
#' |        |        |        |                    |
#' | Item 1 | Item 2 | Item 3 | ================== |
#' ```
#'
#' **`"center"`**
#'
#' ```
#' |        |        |        |                    |
#' | Item 1 | Item 2 | Item 3 | ================== |
#' |        |        |        |                    |
#' ```
#'
#' **`"baseline"`**
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | ================== |
#' |        |        |        |                    |
#' |        |        |        |                    |
#' ```
#'
#' **`"stretch"`**
#'
#' ```
#' | It     | It     | It     | ================== |
#' |   em   |   em   |   em   |                    |
#' |      1 |      2 |      3 |                    |
#' ```
#'
#' @section `wrap`:
#'
#' **`FALSE`**
#'
#' ```
#' | Item | Item | Item | Item | Item | Item |
#' | 1    | 2    | 3    | 4    | 5    | 6    |
#' ```
#'
#' **`TRUE`**
#'
#' ```
#' | Item 1 | Item 2 | Item 3 | Item 4 | === |
#' | Item 5 | Item 6 | ===================== |
#' ```
#'
#' @export
#' @examples
#'
flex <- function(tag, direction = NULL, reverse = NULL, justify = NULL,
                 align = NULL, wrap = NULL) {

  direction <- ensureBreakpoints(direction, c("row", "column"))
  reverse <- ensureBreakpoints(reverse, c(TRUE, FALSE))
  justify <- ensureBreakpoints(justify, c("start", "end", "center", "between", "around"))
  align <- ensureBreakpoints(align, c("start", "end", "center", "baseline", "stretch"))
  wrap <- ensureBreakpoints(wrap, c(TRUE, FALSE))

  if (length(direction) || length(reverse)) {
    for (breakpoint in names(reverse)) {
      old <- direction[[breakpoint]] %||% "row"

      if (reverse[[breakpoint]]) {
        direction[[breakpoint]] <- paste0(old, "-reverse")
      } else {
        direction[[breakpoint]] <- old
      }
    }
  }

  if (length(wrap)) {
    wrap <- lapply(wrap, function(w) if (w) "wrap" else "nowrap")
  }

  classes <- c(
    createResponsiveClasses(direction, "flex"),
    createResponsiveClasses(justify, "justify-content"),
    createResponsiveClasses(align, "align-items"),
    createResponsiveClasses(wrap, "flex")
  )

  tagAddClass(tag, classes)
}
