convertViewport <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  switch(
    x, small = "sm", medium = "md", large = "lg", `extra-large` = "xl", NULL
  )
}

#' Element utilities
#'
#' Utility functions.
#'
#' @format NULL
#' @name utils
#' @export
utils <- structure(
  list(),
  name = "utils",
  class = c("module", "list")
)

#' Flex box and flex item utilities
#'
#' @description
#'
#' These utility functions are used to build flex layouts and are viewport
#' responsive.
#'
#' @usage
#'
#' utils$flexitem(align = NULL, margin = NULL, order = NULL, viewport = NULL)
#'
#' utils$flexbox(direction = NULL, reverse = FALSE, justify = NULL,
#'   align = NULL, content = NULL, wrap = NULL, viewport = NULL)
#'
#' @param viewport One of `"small"`, `"medium"`, `"large"`, or `"extra-large"`,
#'   specifying the minimum screen size at which specified styles are applied,
#'   defaults to `NULL`. Multiple `util$*` calls may be [collate]d together to
#'   specify different layouts for element(s) depending on screen size. When
#'   `viewport` is `NULL` specified styles will apply to the smallest screens on
#'   up. Not all styles have this functionality.
#'
#' @param direction One of `"row"` or `"column"` specifying the direction of a
#'   flex container's items, defaults to `"row"`.
#'
#'   Row-wise flex containers handle elements from left to right in rows, the
#'   *main axis is the x-axis*, and the *cross axis is the y-axis*.
#'
#'   Column-wise flex containers handle elements from top to bottom in columns,
#'   the *main axis is y-axis*, and the *cross axis is the x-axis*.
#'
#' @param reverse If `TRUE`, the ordering of flex items inside a flex container
#'   is reversed *and* the items are aligned to the right side of the container,
#'   defaults to `FALSE`. This argument has no effect unless `direction` is
#'   specified.
#'
#' @param justify One `"start"`, `"end"`, `"center"`, `"between"`, or `"around"`
#'   specifying how a flex containers items are aligned along the *main axis*,
#'   defaults to `NULL`. Note that setting `justify` to `"end"` is not the same
#'   as setting `reverse` to `TRUE`. Unlike `align`, there is no flex item
#'   equivalent of `justify`.
#'
#' @param align One of `"start"`, `"end"`, `"center"`, `"baseline"`, or
#'   `"stretch"` specifying how a flex container aligns items or how a flex item
#'   aligns itself within a flex container along the *cross axis*, defaults to
#'   `NULL`. Note that, `"start"` and `"baseline"` are noticeably different only
#'   when the content or font size of flex items are not the same. This is
#'   because baseline aligns items according to the bottom of an item's content.
#'
#' @param content One of `"start"`, `"end"`, `"center"`, `"between"`,
#'   `"around"`, or `"stretch"`, defaults to `NULL`.
#'
#' @param wrap One of `"nowrap"`, `"wrap"`, or `"reverse"` specifying how flex
#'   items will wrap inside a flex container, defaults to `NULL`. If `"nowrap"`,
#'   items are condensed so as to fit on a single row or column, possibly
#'   extending past the boundary of the parent flex container. If `"wrap"` or
#'   `"reverse"`, items are not condensed and will wrap within the parent flex
#'   container onto new rows or columns.
#'
#' @param margin One of `"left"`, `"right"`, `"top"`, or `"bottom"` specifying
#'   an auto margin for a flex item, defaults to `NULL`. On an aligned axis,
#'   a flex item with an auto margin will push away its sibling items. On a
#'   justified axis, a flex item with an auto margin will push itself away from
#'   siblings.
#'
#' @section How it all works:
#'
#' **reverse**
#'
#' Flex container with `reverse = FALSE`.
#'
#' * `| Item 1 | Item 2 | Item 3 | ============= |`
#'
#' Flex container with `reverse = TRUE`
#'
#' * `| ============= | Item 3 | Item 2 | Item 1 |`
#'
#' **justify**
#'
#' Flex container with `justify = "start"`
#'
#' * `| Item 1 | Item 2 | Item 3 | ============= |`
#'
#' Flex container with `justify = "end"`
#'
#' * `| ============= | Item 1 | Item 2 | Item 3 |`
#'
#' Flex container with `justify = "center"`
#'
#' * `| ===== | Item 1 | Item 2 | Item 3 | ===== |`
#'
#' Flex container with `justify = "between"`
#'
#' * `| Item 1 | ===== | Item 2 | ===== | Item 3 |`
#'
#' Flex container with `justify = "around"`
#'
#' * `| = | Item 1 | = | Item 2 | = | Item 3 | = |`
#'
#' **align** (flexbox)
#'
#' Parent flex container with `align = "start"`
#'
#' \itemize{
#' \item
#' ```
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' |        |        |        |               |
#' ```
#' }
#'
#' Parent flex container with `align = "end"`
#'
#' \itemize{
#' \item
#' ```
#' |        |        |        |               |
#' |        |        |        |               |
#' | Item 1 | Item 2 | Item 3 | ============= |
#' ```
#' }
#'
#' Parent flex container with `align = "center"`
#'
#' \itemize{
#' \item
#' ```
#' |        |        |        |               |
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' ```
#' }
#'
#' Parent flex container with `align = "baseline"`
#'
#' \itemize{
#' \item
#' ```
#' | Item 1 | Item 2 | Item 3 | ============= |
#' |        |        |        |               |
#' |        |        |        |               |
#' ```
#' }
#'
#' Parent flex container with `align = "stretch"`
#'
#' \itemize{
#' \item
#' ```
#' | It     | It     | It     | ============= |
#' |   em   |   em   |   em   |               |
#' |      1 |      2 |      3 |               |
#' ```
#' }
#'
#' **align** (flexitem)
#'
#' Parent flex container with `align = "stretch"`, child `Item 2` with `align =
#' "start"`
#'
#' \itemize{
#' \item
#' ```
#' | It     | Item 2 | It     | ============= |
#' |   em   |        |   em   |               |
#' |      1 |        |      3 |               |
#' ```
#' }
#'
#' Parent flex container with `align = "stretch"`, child `Item 2` with `align =
#' "end"`
#'
#' \itemize{
#' \item
#' ```
#' | It     |        | It     | ============= |
#' |   em   |        |   em   |               |
#' |      1 | Item 2 |      3 |               |
#' ```
#' }
#'
#' Parent flex container with `align = "stretch"`, child `Item 2` with `align =
#' "center"`
#'
#' \itemize{
#' \item
#' ```
#' | It     |        | It     | ============= |
#' |   em   |        |   em   |               |
#' |      1 | Item 2 |      3 |               |
#' ```
#' }
#'
#' Parent flex container with `align = "stretch"`, child `Item 2` with `align =
#' "baseline"`
#'
#' \itemize{
#' \item
#' ```
#' | It     | Item 2 | It     | ============= |
#' |   em   |        |   em   |               |
#' |      1 |        |      3 |               |
#' ```
#' }
#'
#' Parent flex container with `align = "stretch"`, child `Item 2` with `align =
#' "stretch"`
#'
#' \itemize{
#' \item
#' ```
#' | It     | It     | It     | ============= |
#' |   em   |   em   |   em   |               |
#' |      1 |      2 |      3 |               |
#' ```
#' }
#'
#'
#' **margin**
#'
#' Parent flex container with `justify = "end"`, child `Item 1` with `margin =
#' "right"` pushes self away from siblings
#'
#' * `| Item 1 | ============= | Item 2 | Item 3 |`
#'
#' Parent flex container with `align = "start"`, child `Item 1` with `margin =
#' "right"` pushes siblings away from self
#'
#' * `| Item 1 | ============= | Item 2 | Item 3 |`
#'
#' Parent flex container with `justify = "start"`, child `Item 3` with `margin =
#' "left"` pushes self away from siblings
#'
#' * `| Item 1 | Item 2 | ============= | Item 3 |`
#'
#' Parent flex container with `align = "end"`, child `Item 1` with `margin =
#' "left"` pushes siblings away from self
#'
#' * `| Item 1 | Item 2 | ============= | Item 3 |`
#'
#' **wrap**
#'
#' Parent flex container with `wrap = "nowrap"`
#'
#' \itemize{
#' \item
#' ```
#' | Item | Item | Item | Item | Item | Item |
#' | 1    | 2    | 3    | 4    | 5    | 6    |
#' ```
#' }
#'
#' Parent flex container with `wrap = "wrap"`
#'
#' \itemize{
#' \item
#' ```
#' | Item 1 | Item 2 | Item 3 | Item 4 | === |
#' | Item 5 | Item 6 |                       |
#' ```
#' }
#'
#' Parent flex container with `wrap = "reverse"`
#'
#' \itemize{
#' \item
#' ```
#' | Item 5 | Item 6 |                       |
#' | Item 1 | Item 2 | Item 3 | Item 4 | === |
#' ```
#' }
#'
#' @seealso
#'
#' For more information about bootstrap HTML utility classes please refer to the
#' online [reference page](https://v4-alpha.getbootstrap.com/utilities/).
#'
#' @family utilities
#' @aliases flexitem
#' @name flexbox
#' @examples
#'
#' # stub
#'
NULL

# great SO post on the distinction between align-start and baseline
# https://stackoverflow.com/questions/34606879/whats-the-difference-between-flex-start-and-baseline

utils$flexbox <- function(direction = NULL, reverse = FALSE, justify = NULL,
                          align = NULL, content = NULL, wrap = NULL,
                          viewport = NULL) {
  if (!re(direction, "row|column")) {
    stop(
      'invalid `utils$flexbox` argument, `direction` must be one of "row" or ',
      '"column"',
      call. = FALSE
    )
  }

  if (!re(align, "start|end|center|baseline|stretch")) {
    stop(
      'invalid `utils$flexbox` argument, `align` must be one of "start", ',
      '"end", "center", "baseline", or "stretch"',
      call. = FALSE
    )
  }

  if (!re(content, "start|end|center|between|around")) {
    stop(
      'invalid `utils$flexbox` argument, `content` must be one of "start", ',
      '"end", "center", "between", or "around"',
      call. = FALSE
    )
  }

  if (!re(wrap, "nowrap|wrap|reverse")) {
    stop(
      'invalid `utils$flexbox` argument, `wrap` must be one of "nowrap", ',
      '"wrap", or "reverse"',
      call. = FALSE
    )
  }

  if (!re(viewport, "small|medium|large|extra-large")) {
    stop(
      'invalid `utils$flexbox` argument, `viewport` must be one of "small", ',
      '"medium", "large", or "extra-large"',
      call. = FALSE
    )
  }

  viewport <- convertViewport(viewport)

  c(
    "d-flex",
    if (!is.null(direction)) {
      collate(
        "flex",
        viewport,
        direction,
        if (reverse) "reverse",
        collapse = "-"
      )
    },
    if (!is.null(justify)) {
      collate("justify-content", viewport, justify, collapse = "-")
    },
    if (!is.null(align)) {
      collate("align-items", viewport, align, collapse = "-")
    },
    if (!is.null(content)) {
      collate("align-content", viewport, content, collapse = "-")
    },
    if (!is.null(wrap)) {
      collate(
        "flex", viewport, if (wrap == "reverse") "wrap", wrap, collapse = "-"
      )
    }
  )
}

utils$flexitem <- function(align = NULL, margin = NULL, order = NULL,
                           viewport = NULL) {
  if (!re(align, "start|end|center|baseline|stretch")) {
    stop(
      'invalid `utils$flexitem` argument, `align` must be one of "start", ',
      '"end", "center", or "baseline"',
      call. = FALSE
    )
  }

  if (!re(margin, "top|left|bottom|right")) {
    stop(
      'invalid `utils$flexitem` argument, `margin` must be one of "top", ',
      '"left", "bottom", or "right"',
      call. = FALSE
    )
  }

  if (!re(order, "first|last|unordered")) {
    stop(
      'invalid `utils$flexitem` argument, `order` must be one of "first", ',
      '"last", or "unordered"',
      call. = FALSE
    )
  }

  if (!re(viewport, "small|medium|large|extra-large")) {
    stop(
      'invalid `utils$flexitem` argument, `viewport` must be one of "small", ',
      '"medium", "large", or "extra-large"',
      call. = FALSE
    )
  }

  viewport <- convertViewport(viewport)

  c(
    if (!is.null(align)) {
      collate("align-self", viewport, align, collapse = "-")
    },
    if (!is.null(margin)) {
      paste0("m", substr(margin, 1, 1), "-auto")
    },
    if (!is.null(order)) {
      collate("order", viewport, order, collapse = "-")
    }
  )
}

utils$border <- function(remove = NULL, round = NULL) {
  if (!re(remove, "all|left|top|right|bottom")) {
    stop(
      'invalid `utils$border` argument, `remove` must be one of "all", ',
      '"left", "top", "right", or "bottom"',
      call. = FALSE
    )
  }

  if (!re(round, "all|none|left|top|right|bottom|circle")) {
    stop(
      'invalid `utils$border` argument, `round` must be one of "all", "none", ',
      '"left", "top", "right", "bottom", or "circle"',
      call. = FALSE
    )
  }

  remove <- unique(remove)
  round <- unique(round)

  c(
    ifelse(remove == "all", "border-0", paste0("border-", remove)),
    vapply(
      round,
      function(r) paste0("rounded", if (r == "none") "-0" else if (r == "all")
        "" else paste0("-", r)),
      character(1)
    )
  )
}

utils$clearfix <- function() {
  "clearfix"
}

utils$close <- function() {
  "close"
}

#' Color text and backgrounds
#'
#' Utilities functions to change element text or background color. These
#' utilities are intended to give visual context to blocks of text or elements.
#' When using a dark background one may want to specify a lighter color for
#' any element text.
#'
#' @usage
#'
#' utils$text(context)
#'
#' utils$background(context)
#'
#' @param context A character string specifying the visual context of a block of
#'   text or background color of an element.
#'
#'   For **`utils$text`**, one of `"muted"`, `"primary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, or `"white"`.
#'
#'   For **`utils$background`**, one of `"muted"`, `"primary"`, `"success"`,
#'   `"info"`, `"warning"`, `"danger"`, `"inverse"` or `"faded"`.
#'
#' @family utilities
#' @name colors
NULL

utils$text <- function(context) {
  if (!re(context, "muted|primary|success|info|warning|danger|white")) {
    stop(
      'invalid `utils$text` argument, `context` must be one of "muted", ',
      '"primary", "success", "info", "warning", "danger", or "white"',
      call. = FALSE
    )
  }

  paste0("text-", context)
}

utils$background <- function(context) {
  if (!re(context, "primary|success|info|warning|danger|inverse|faded")) {
    stop(
      'invalid `utils$background` argument, `context` must be one of ',
      '"primary", "success", "info", "warning", "danger", "inverse", or ',
      '"faded"',
      call. = FALSE
    )
  }

  paste0("bg-", context)
}

# utils$bg <- function(context) {
#   if (!re(context, "primary|success|info|warning|danger|inverse|faded")) {
#     stop(
#       'invalid `utils$bg` argument, `context` must be one of "primary", ',
#       '"success", "info", "warning", "danger", "inverse", or "faded"',
#       call. = FALSE
#     )
#   }
#
#   utils$background(context)
# }

#' Responsive hidden elements
#'
#' These utility functions allow elements to hide responsively depending on the
#' viewport size.
#'
#' @usage
#'
#' utils$hidden(above = NULL, below = NULL)
#'
#' @param above One of `"small"`, `"medium"`, `"large"`, or `"extra-large"`
#'   specifying the minimum viewport size at which to start hiding the element,
#'   e.g. if `above = "medium"` an element is hidden on medium, large, and
#'   extra large viewports.
#'
#' @param below One of `"small"`, `"medium"`, `"large"`, or `"extra-large"`
#'   specifying the maximum viewport size at which an element is hidden,
#'   e.g. if `below = "medium"` an element is hidden on extra small, small,
#'   and medium viewports.
#'
#' @family utilities
#' @name hidden
NULL

utils$hidden <- function(above = NULL, below = NULL) {
  if (!re(above, "small|medium|large|extra-large")) {
    stop(
      'invalid `utils$hidden` argument, `above` must be one of "small", ',
      '"medium", "large", or "extra-large"',
      call. = FALSE
    )
  }

  if (!re(below, "small|medium|large|extra-large")) {
    stop(
      'invalid `utils$hidden` argument, `below` must be one of "small", ',
      '"medium", "large", or "extra-large"',
      call. = FALSE
    )
  }

  above <- above %||% ""
  above <- switch(above, small = "sm", medium = "md", large = "lg",
                  `extra-large` = "xl", NULL)

  below <- below %||% ""
  below <- switch(below, small = "sm", medium = "md", large = "lg",
                  `extra-large` = "xl", NULL)

  c(
    if (!is.null(above)) {
      collate("hidden", above, "above", collapse = "-")
    },
    if (!is.null(below)) {
      collate("hidden", below, "below", collapse = "-")
    }
  )
}

#' Affix elements
#'
#' These utility functions are used to affix elements to the top or bottom of
#' a page. When the page is scrolled affixed elements will remain on the top
#' or bottom. A sticky element is affixed to the top of the page once the page
#' scrolls past it. Note that the CSS used in the sticky functionality is not
#' fully supported by all browsers.
#'
#' @usage
#'
#' utils$position(fixed)
#'
#' @param fixed One of `"top"`, `"bottom"`, or `"sticky"` positioning and
#'  fixing an element to the top or bottom of the viewport. If `"sticky"`,
#'  the element is only fixed to the top of the viewport after scrolling past
#'  it.
#'
#' @family utilities
#' @name position
NULL

utils$position <- function(fixed) {
  if (!re(fixed, "top|bottom|sticky", len0 = FALSE)) {
    stop(
      'invalid `utils$position` argument, `fixed` must be one of "top", ',
      '"bottom", or "sticky"',
      call. = FALSE
    )
  }

  if (fixed == "sticky") {
    "sticky-top"
  } else {
    paste0("fixed-", fixed)
  }
}

#' Responsive floated elements
#'
#' These utility functions float an element to the left or right of its parent.
#' Alternatively, one can specify `"none"` to disable an element's float.
#'
#' @usage
#'
#' utils$float(side, viewport = NULL)
#'
#' @param side One of `"left"`, `"right"`, or `"none"`, Which side of the parent
#'   element to float the text on or if `"none"` the element cannot be floated.
#'
#' @family utilities
#' @name float
NULL

utils$float <- function(side, viewport = NULL) {
  if (!re(side, "left|right|none", len0 = FALSE)) {
    stop(
      'invalid `utils$float` argument, `side` must be one of "left", "right", ',
      '"none"',
      call. = FALSE
    )
  }

  if (!re(viewport, "small|medium|large|extra-large")) {
    stop(
      'invalid `utils$float` argument, `viewport` must be one of "small", ',
      '"medium", "large", or "extra-large"',
      call. = FALSE
    )
  }

  viewport <- convertViewport(viewport)

  if (!is.null(side)) {
    collate("float", viewport, side, collapse = "-")
  }
}

#' Element sizing
#'
#' Construct utility classes to modify an element's width or height. The width
#' and height of a child element are controlled relative to their parent's
#' width and height, respectively.
#'
#' @usage
#'
#' utils$width(percentage = NULL, max = NULL)
#'
#' utils$height(percentage = NULL, max = NULL)
#'
#' @param percentage One of 25, 50, 75, or 100 specifying an element's width or
#'   height of an element as a percentage of its parent's width or height,
#'   respectively, defaults to `NULL`.
#'
#' @param max One of 25, 50, 75, or 100 specifying an element's maximum width or
#'   height as a percentage of its parent's width or height, respectively,
#'   defaults to `NULL`.
#'
#' @family utilities
#' @name sizing
NULL

utils$width <- function(percentage = NULL, max = NULL) {
  if (!re(percentage, "25|50|75|100")) {
    stop(
      "invalid `utils$width` argument, `percentage` must be one of 25, 50, ",
      "75, or 100",
      call. = FALSE
    )
  }

  if (!re(max, "20|50|75|100")) {
    stop(
      "invalid `utils$width` argument, `max` must be one of 25, 50, 75, or ",
      "100"
    )
  }

  c(
    if (!is.null(percentage)) paste0("w-", percentage),
    if (!is.null(max)) paste0("mw-", max)
  )
}

utils$height <- function(percentage = NULL, max = NULL) {
  if (!re(percentage, "25|50|75|100")) {
    stop(
      "invalid `utils$height` argument, `percentage` must be one of 25, 50, ",
      "75, or 100",
      call. = FALSE
    )
  }

  if (!re(max, "20|50|75|100")) {
    stop(
      "invalid `utils$height` argument, `max` must be one of 25, 50, 75, or ",
      "100"
    )
  }

  c(
    if (!is.null(percentage)) paste0("h-", percentage),
    if (!is.null(max)) paste0("mh-", max)
  )
}

#' Element Spacing
#'
#' Use these utilities to add responsive padding or margins to a tag element.
#' Both `margin` and `padding` are viewport responsive. Margin and padding sizes
#' are specified relative to the font size of a page's root `<html>` element.
#'
#' @usage
#'
#' utils$margin(size, side = "all", viewport = NULL)
#'
#' utils$padding(size, side = "all", viewport = NULL)
#'
#' @param size An integer, 0 through 5, specifying the relative adjustment of an
#'   element's margin or padding, where 3 is the default amount of spacing, 1 is
#'   0.25 times the default, and 5 is 3 times the default. 0 removes margins or
#'   padding.
#'
#' @param side One of `"top"`, `"left"`, `"bottom"`, `"right"`, or `"all"`
#'   specifying which side(s) to apply spacing to, defaults to `"all"`.
#'
#' @param viewport One of `"small"`, `"medium"`, `"large"`, or `"extra-large"`,
#'   specifying the screen size at which the style is applied, defaults
#'   to `NULL`.
#'
#' @seealso
#'
#' The complete list of [utilities][utilities]. For more on viewport
#' responsiveness see [viewport].
#'
#' @family utilities
#' @name spacing
NULL

utils$margin <- function(size, side = "all", viewport = NULL) {
  if (!re(size, "[0-5]")) {
    stop(
      "invalid `utils$margin` argument, `size` must be one of 0, 1, 2, 3, 4, ",
      "or 5",
      call. = FALSE
    )
  }

  if (!re(side, "top|bottom|left|right|all")) {
    stop(
      'invalid `utils$margin` argument, `side` must be on of "top", ',
      '"bottom", "left", or "right"',
      call. = FALSE
    )
  }

  prefix <- paste0("m", if (side != "all") substr(side, 1, 1))

  collate(prefix, convertViewport(viewport), size, collapse = "-")
}

utils$padding <- function(size, side = "all", viewport = NULL) {
  if (!re(size, "[0-5]")) {
    stop(
      "invalid `utils$padding` argument, `size` must be one of 0, 1, 2, 3, 4, ",
      "or 5",
      call. = FALSE
    )
  }

  if (!re(side, "top|bottom|left|right|all")) {
    stop(
      'invalid `utils$padding` argument, `side` must be on of "top", ',
      '"bottom", "left", or "right"',
      call. = FALSE
    )
  }

  prefix <- paste0("p", if (side != "all") substr(side, 1, 1))

  collate(prefix, convertViewport(viewport), size, collapse = "-")
}

#' Viewport
#'
#' @description
#'
#' Many styles are viewport responsive. These styles change depending on the
#' size of the viewing application. This allows the programmer to build content
#' which can adapt to laptop screens, mobile devices, and more.
#'
#' Responsive styles are applied depending on the width of the viewport. Extra
#' small screens are 0 px and up. Small screens are 576 px and up. Medium
#' screens are 768 px and up. Large screens are 992 px and up. Extra large
#' screens are 1200 px and up.
#'
#' @family utilities
#' @name viewport
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       listGroup(
#'         class = collate(
#'           utils$margin(0),
#'           utils$margin(5, "left", "medium"),
#'           utils$margin(5, "right", "medium")
#'         ),
#'         listGroupItem(
#'           class = utils$bg("info"),
#'           label = "Hello, world!"
#'         ),
#'         listGroupItem(
#'           class = utils$bg("info"),
#'           label = "Goodnight, moon!"
#'         )
#'       )
#'
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
NULL
