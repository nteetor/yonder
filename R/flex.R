viewport <- function(v) {
  if (v == "") {
    return("")
  }

  switch(
    v,
    xs = "xs",
    `extra-small` = "xs",
    sm = "sm",
    small = "sm",
    md = "md",
    medium = "md",
    lg = "lg",
    large = "lg",
    xl = "xl",
    `extra-large` = "xl",
    stop(
      "invalid viewport ", v, " specified, must be one of small, medium, ",
      "large, `extra-large`",
      call. = FALSE
      )
  )
}

direction <- function(dir, rev) {
  if (is.null(dir)) {
    return(NULL)
  }

  dir <- sort(dir)
  rev <- sort(rev)

  if (all(names2(dir) == names2(rev))) {
    stop(
      "argument `reverse` must include a corresponding value for each value ",
      "of `direction`",
      call. = FALSE
    )
  }

  names(dir) <- ifelse(names2(dir) == "", "-", names2(dir))

  paste0(
    Map(
      function(v, d, r) paste0("flex-", v, if (v != "") "-"),
      NULL
    )
  )

  collate(
    "flex",
    viewport,
    direction,
    if (reverse) "reverse",
    collapse = "-"
  )
}

alignment <- function(align) {
  if (is.null(align)) {
    return(NULL)
  }

  paste0(
    Map(
      function(v, a) paste0("align-items-", viewport(v), if (v != "") "-", a),
      names2(align),
      align
    ),
    collapse = " "
  )
}

#' Flex box and flex item utilities
#'
#' Convert tags into flex boxes and flex items. These functions may be chained
#' together to specify different flex behavior for different viewports.
#' Multi length arguments may be passed to flexbox and flexitem. The name
#' of each argument should be one of `small`, `sm`, `medium`, `md`, `large`,
#' `lg`, `extra-large`, `lg` or blank (`extra-small`) indicating a viewport
#' size at which to apply the flex behavior.
#'
#' @param viewport One of `"small"`, `"medium"`, `"large"`, or `"extra-large"`,
#'   specifying the minimum screen size at which specified flex behavior is
#'   applied, defaults to `NULL`.
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
#' @section Better understanding flex behavior:
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
#' @aliases flexitem
#' @name flexbox
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
flexbox <- function(..., direction = NULL, reverse = FALSE,
                    justify = NULL, align = NULL, content = NULL, wrap = NULL) {
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

#' @rdname flexbox
#' @export
flexitem <- function(align = NULL, margin = NULL, order = NULL,
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
