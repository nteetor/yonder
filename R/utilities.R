# or is it sea haven?
seehaven <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }
  switch(
    x, small = "sm", medium = "md", large = "lg", `extra-large` = "xl", NULL
  )
}

#' Bootstrap utilities
#'
#' @description
#'
#' Include these in builder function `...` arguments to apply a style using
#' bootstrap's HTML utility classes.
#'
#' @usage
#'
#' utils$border(remove = NULL, round = NULL)
#'
#' utils$clearfix()
#'
#' utils$close()
#'
#' utils$text(context = NULL, align = NULL)
#'
#' utils$background(context)
#'
#' utils$bg(context)
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
#' @param above,below One of `"small"`, `"medium"`, `"large"`, or
#'   `"extra-large"`, specifying a screen size, defaults to `NULL`. Used by
#'   `utils$hidden` to indicate a screen size at which content is hidden. If
#'   `above` and `below` are the same value then an element will only appear that
#'   particular screen size.
#'
#' @param context One of `"muted"`, `"primary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, for backgrounds only `"inverse"` and `"faded"` and
#'   for text only `"white"`, specifying a visual context for a block of text.
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
#' @section Visuals:
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
#' @format NULL
#' @name utils
#' @export
#' @examples
#'
#' # stub
#'
utils <- list()

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

utils$text <- function(context = NULL, align = NULL) {
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

utils$bg <- function(context) {
  if (!re(context, "primary|success|info|warning|danger|inverse|faded")) {
    stop(
      'invalid `utils$bg` argument, `context` must be one of "primary", ',
      '"success", "info", "warning", "danger", "inverse", or "faded"',
      call. = FALSE
    )
  }

  utils$background(context)
}


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

  viewport <- seehaven(viewport)

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

  viewport <- seehaven(viewport)

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

utils$display <- function() {

}

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

utils$position <- function(fixed = NULL) {
  if (!re(fixed, "top|bottom|sticky")) {
    stop(
      'invalid `utils$position` argument, `fixed` must be one of "top", ',
      '"bottom", or "sticky"',
      call. = FALSE
    )
  }

  if (!is.null(fixed)) {
   if (fixed == "sticky") {
     "sticky-top"
   } else {
     paste0("fixed-", fixed)
   }
  }
}

utils$float <- function(side = NULL, viewport = NULL) {
  if (!re(side, "left|right|none")) {
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

  viewport <- seehaven(viewport)

  if (!is.null(side)) {
    collate("float", viewport, side, collapse = "-")
  }
}

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

utils$margin <- function(size, side = "all", viewport = NULL) {
  if (!re(size, "[012345]")) {
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

  collate(prefix, viewport, size, collapse = "-")
}

utils$padding <- function(size, side = "all", viewport = NULL) {
  if (!re(size, "[012345]")) {
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

  collate(prefix, viewport, size, collapse = "-")
}
