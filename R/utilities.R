#' Element borders
#'
#' Apply borders, border colors, and border radius to a tag element.
#'
#' @param tag A tag element object.
#'
#' @param sides One of `"all"`, `"none"`, or one or more of `"top"`, `"right"`,
#'   `"bottom"`, `"left"` specifying the sides to apply a border, defaults to
#'   `"all"`.
#'
#' @param color One of `NULL`, `"primary"`, `"secondary"`, `"success"`,
#'   `"info"`, `"warning"`, `"danger"`, `"light"`, `"dark"`, or `"white"`
#'   specifying the visual context and border color. If `NULL`, the border is
#'   the browser default.
#'
#' @param rounded One of `"all"`, `"circle"`, `"none"`, or one or more of
#'   `"top"`, `"right"`, `"bottom"`, `"left"` specifying the side whose corners
#'   to round.
#'
#' @export
#' @examples
#' tags$h1("Hello, world!") %>%
#'   border(sides = c("top", "bottom"))
#'
#' tags$div() %>%
#'   border(color = "warning")
#'
border <- function(tag, sides = "all", color = NULL, rounded = "none") {
  if ((length(sides) > 1 && any(re(sides, "all|none", FALSE))) ||
      !all(re(sides, "top|right|bottom|left|all|none", FALSE))) {
      stop(
        "invalid `border` argument, `sides` must be ",
        '"all", "none", or one or more of ',
        '"top", "right", "bottom", or "left"',
        call. = FALSE
      )
  }

  if ((!is.null(color) && length(sides) != 1) ||
      !re(color, "primary|secondary|success|info|warning|danger|light|dark|white")) {
    stop(
      "invalid `border` argument, `color` must be one of NULL, ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", or "white"',
      call. = FALSE
    )
  }

  if ((length(rounded) > 1 && any(re(sides, "all|circle|none", FALSE))) ||
      !all(re(rounded, "top|right|bottom|left|all|none", FALSE))) {
    stop(
      "invalid `border` argument, `sides` must be ",
      '"all", "none", or one or more of',
      '"top", "right", "bottom", or "left"',
      call. = FALSE
    )
  }

  tag <- tagEnsureClass(tag, "border")

  if (length(sides) == 1) {
    if (sides == "none") {
      tag <- tagAppendAttributes(tag, class = "border-0")
    }
  } else {
    remove <- setdiff(c("top", "right", "bottom", "left"), sides)

    tag <- tagAppendAttributes(
      tag,
      class = paste0("border-", remove, "-0", collapse = " ")
    )
  }

  if (length(rounded) == 1) {
    if (rounded == "none") {
      tag <- tagAppendAttributes(tag, class = "rounded-0")
    }
  } else {
    tag <- tagAppendAttributes(
      tag,
      class = paste0("rounded-", rounded, collapse = " ")
    )
  }

  tag
}

#' Element margins and padding
#'
#' @description
#'
#' These functions are used in conjunction with [tagReduce] to change the
#' padding or margins of a tag. Each argument value may be a single value or a
#' vector of four values. Margins and padding are specified as 0, 1, 2, 3, 4, or
#' 5. 0 removes any margins or padding. 5 is equivalent to `3rem` (`rem` is a
#' relative unit of measurement in css).
#'
#' Specifying a single value changes the margin or padding of all four tag
#' sides. To apply different margins or padding to each side pass a vector of
#' four values. In this case, the first value is for the top side, second for
#' the left side, third for the bottom side, and the fourth value is for the
#' left side. As a wise help page once said, think "**tr**ou**bl**e" to help
#' remember the order.
#'
#' @param default One of 0, 1, 2, 3, 4, 5 specifying the default margins or
#'   padding to apply. If the margins and padding remain the same across all
#'   viewports then only `default` needs to be specified.
#'
#' @param sm Like `default`, but the margins or padding are applied once the
#'   viewport is 576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the margins or padding are applied once the
#'   viewport is 768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the margins or padding are applied once the
#'   viewport is 992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the margins or padding are applied once the
#'   viewport is 1200 pixels wide, think large desktop.
#'
#' @family utilities
#' @export
padding <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm , md = md, lg = lg, xl = xl))

  if (length(args) == 0) {
    stop(
      "invalid `padding` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  classes <- vapply(
    names2(args),
    function(nm) {
      arg <- args[[nm]]

      if (!all(arg %in% 0:5)) {
        stop(
          "invalid `padding` argument, `", nm, "` value(s) must be 0, 1, 2, 3, 4, or 5",
          call. = FALSE
        )
      }

      if (length(arg) != 1 && length(arg) != 4) {
        stop(
          "invalid `padding` argument, `", nm, "` must be a single value or a vector of 4 values",
          call. = FALSE
        )
      }

      prefix <- "p"
      sides <- c("t", "r", "b", "l")

      breakpoint <- if (nm == "default") "-" else paste0("-", nm, "-")

      if (length(default) == 4) {
        return(paste0(prefix, sides, breakpoint, arg, collapse = " "))
      }

      paste0(prefix, breakpoint, arg)
    },
    character(1)
  )

  tagAppendAttributes(tag, class = collate(classes))
}

#' @rdname padding
#' @export
margins <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  if (length(args) == 0) {
    stop(
      "invalid `margins` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  prefix <- "m"
  sides <- c("t", "r", "b", "l")

  classes <- vapply(
    names2(args),
    function(nm) {
      arg <- args[[nm]]

      if (!all(arg %in% 0:5)) {
        stop(
          "invalid `margins` argument, `", nm, "` value(s) must be 0, 1, 2, 3, 4, or 5",
          call. = FALSE
        )
      }

      if (length(arg) != 4 && length(arg) != 1) {
        stop(
          "invalid `margins` argument, `", nm, "` must be a single value or a vector of four values",
          call. = FALSE
        )
      }

      breakpoint <- if (nm == "default") "-" else paste0("-", nm, "-")

      if (length(arg) == 4) {
        return(paste0(prefix, sides, breakpoint, arg, collapse = " "))
      }

      paste0(prefix, breakpoint, arg)
    },
    character(1)
  )

  tagAppendAttributes(tag, class = collate(classes))
}

#' Tag width and height
#'
#' Used in conjunction with [tagReduce] to change a tag element's width or
#' height. Widths and heights are specified as percentages of the parent
#' object's width or height.
#'
#' @param percentage One of 25, 50, 75, or 100 specifying width or height as a
#'   percentage of a parent element's width or height.
#'
#' @param max One of 25, 50, 75, or 100 specifying max width or max height as a
#'   percentage of a parent element's width or height.
#'
#' @export
#' @examples
#' tagReduce(
#'   width(25),
#'   height(100)
#'   tags$div()
#' )
#'
#' tagReduce(
#'   width(max = 75),
#'   tags$div()
#' )
#'
width <- function(tag, percentage = NULL, max = NULL) {
  if (is.null(percentage) && is.null(max)) {
    stop(
      "invalid `width` arguments, `percentage` and `max` may not both be NULL",
      call. = FALSE
    )
  }

  if (!is.null(percentage) && !(percentage %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `width` argument, `percentage` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `width` argument, `max` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  tagAppendAttributes(
    tag,
    class = collate(
      percentage %??% paste0("w-", percentage),
      max %??% paste0("mw-", max)
    )
  )
}

#' @rdname width
#' @export
height <- function(percentage = NULL, max = NULL) {
  if (is.null(percentage) && is.null(max)) {
    stop(
      "invalid `height` arguments, `percentage` and `max` may not both be NULL",
      call. = FALSE
    )
  }

  if (!is.null(percentage) && !(percentage %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `height` argument, `percentage` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {
    stop(
      "invalid `height` argument, `max` must be one of 25, 50, 75, or 100",
      call. = FALSE
    )
  }

  tagAppendAttributes(
    tag,
    class = collate(
      percentage %??% paste0("h-", percentage),
      max %??% paste0("mh-", max)
    )
  )

}

# Apply styles to a tag
#
# This function applies any number of styles generated by utility function
# calls.
#
# @param ... Any number of utility function calls **and** one tag object.
#
# @export
# @examples
# tagReduce(
#   width(25),
#   padding(3),
#   tags$div()
# )
#
# tagReduce(
#   margins(sm = 1, xl = 5),
#   tags$span()
# )
#
tagReduce <- function(...) {
  args <- list(...)

  tag_objs <- vapply(args, is_tag, logical(1))

  if (!any(tag_objs)) {
    stop(
      "invalid call to `tagReduce`, one argument must be a tag object",
      call. = FALSE
    )
  }

  if (sum(tag_objs) > 1) {
    stop(
      "invalid call to `tagReduce`, only one argument may be a tag object",
      call. = FALSE
    )
  }

  funs <- args[!tag_objs]
  tag <- args[tag_objs][[1]]

  if (length(funs) == 0) {
    return(tag)
  }

  Reduce(function(acc, fun) fun(acc), funs, init = tag)
}

