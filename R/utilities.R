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
#' @param context One of `NULL`, `"primary"`, `"secondary"`, `"success"`,
#'   `"info"`, `"warning"`, `"danger"`, `"light"`, `"dark"`, or `"white"`
#'   specifying the visual context and border color. If `NULL`, the border is
#'   the browser default.
#'
#' @param rounded One of `"all"`, `"circle"`, `"none"`, or one or more of
#'   `"top"`, `"right"`, `"bottom"`, `"left"` specifying the side whose corners
#'   to round.
#'
#' @family utilities
#' @export
#' @examples
#' tags$h1("Hello, world!") %>%
#'   border(sides = c("top", "bottom"))
#'
#' tags$div() %>%
#'   border(context = "warning")
#'
border <- function(tag, sides = "all", rounded = "none", context = NULL) {
  if ((length(sides) > 1 && any(re(sides, "all|none", FALSE))) ||
      !all(re(sides, "top|right|bottom|left|all|none", FALSE))) {
      stop(
        "invalid `border` argument, `sides` must be ",
        '"all", "none", or one or more of ',
        '"top", "right", "bottom", or "left"',
        call. = FALSE
      )
  }

  if ((!is.null(context) && length(sides) != 1) ||
      !re(context, "primary|secondary|success|info|warning|danger|light|dark|white")) {
    stop(
      "invalid `border` argument, `context` must be one of NULL, ",
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

#' Element text color, font case, font weight, and more
#'
#' The `text` helper function applies text related Boostrap classes to a tag
#' element. These classes apply CSS to change text color, alignment, or case.
#'
#' @param tag A tag element.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, `"light"`, `"dark"`, `"muted"`, or `"white"`
#'   specifying the visual context of the text. `"white"` is best suited for
#'   elements with dark backgrounds. Defaults to `NULL`, the element text color
#'   is left as is.
#'
#' @param align One of `"justify"`, `"left"`, `"right"`, or `"center"`
#'   specifying the alignment of an element's text. Defaults to `NULL`, no
#'   alignment is applied, however the CSS default is to left align element
#'   text.
#'
#' @param truncate One of `TRUE` or `FALSE` specifying whether or not an
#'   element's text is truncated. Defaults to `FALSE`, the element text is left
#'   as is.
#'
#' @param case One of `"upper"`, `"lower"`, or `"capitalize"` specifying a
#'   transformation of an element's text. Defaults to `NULL`, element case is
#'   left as is. `"capitalize"` changes only the first letter to upper case,
#'   all other characters are left as is.
#'
#' @family utilities
#' @export
#' @examples
#' tags$span("hello, world!") %>%
#'   text(context = "warning", case = "upper")
#'
#' tags$div("Goodnight, moon") %>%
#'   text(truncate = TRUE, weight = "bold") %>%
#'   text("success")
#'
#' tags$div("Howdy") %>%
#'   text("white") %>%
#'   background("dark")
#'
text <- function(tag, context = NULL, align = NULL, truncate = FALSE,
                 case = NULL, weight = NULL, style = NULL) {
  if (!re(context, "primary|secondary|success|info|warning|danger|light|dark|muted|white")) {
    stop(
      "invalid `text` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", "muted", or "white"',
      call. = FALSE
    )
  }

  if (!re(align, "left|right|center|justify")) {
    stop(
      "invalid `text` argument, `align` must be one of ",
      '"justify", "left", "right", or "center"',
      call. = FALSE
    )
  }

  if (truncate != TRUE && truncate != FALSE) {
    stop(
      "invalid `text` argument, `truncate` must be one of TRUE or FALSE",
      call. = FALSE
    )
  }

  if (!re(case, "upper|lower|capitalize")) {
    stop(
      "invalid `text` argument, `case` must be one of ",
      '"upper", "lower", or "capitalize"',
      call. = FALSE
    )
  }

  if (!is.null(context)) {
    context <- paste0("text-", context)
    tag <- tagDropContext(tag, "text")
    tag <- tagAddClass(tag, context)
  }

  if (!is.null(align)) {
    align <- paste0("text-", align)
    tag <- tagDropClass(tag, "text-(left|right|center|justify)")
    tag <- tagAddClass(tag, align)
  }

  if (truncate) {
    tag <- tagEnsureClass(tag, "text-truncate")
  }

  if (!is.null(case)) {
    case <- paste0("text-", case)
    tag <- tagDropClass(tag, "text-(lowercase|uppercase|capitalize)")
    tag <- tagAddClass(tag, case)
  }

  tag
}

#' Text font and styles
#'
#' The `font` utility function applies Bootstrap classes to a tag element.
#' These classes apply CSS to change the font weight of an element's text or the
#' font style of an element text.
#'
#' @param tag A tag element.
#'
#' @param weight One of `"bold"`, `"normal"`, or `"light"` specifying the font
#'   weight of an element's text. Defaults to `NULL`, element font weight is
#'   left as is.
#'
#' @param style One of `"bold"` or `"italic"` specifying the font style of an
#'   element. Defaults to `NULL`, element font style is left as is. Specifying
#'   `"bold"` is equivalent to `weight = "bold"`.
#'
#' @family utilities
#' @export
#' @examples
#' tags$span("This and other news") %>%
#'   font(weight = "light")
#'
font <- function(tag, weight = NULL, style = NULL) {
  if (!re(weight, "bold|normal|light")) {
    stop(
      "invalid `text` argument, `weight` must be one of ",
      '"bold", "normal", or "light"',
      call. = FALSE
    )
  }

  if (!re(style, "bold|italic")) {
    stop(
      "invalid `text` arugment, `style` must be one of ",
      '"bold" or "italics"',
      call. = FALSE
    )
  }

  if (!is.null(weight)) {
    weight <- paste0("font-weight-", weight)
    tag <- tagDropClass(tag, "font-weight-(bold|normal|light)")
    tag <- tagAddClass(tag, weight)
  }

  if (!is.null(style)) {
    if (style == "italic") {
      tag <- tagEnsureClass(tag, "font-italic")
    } else if (style == "bold") {
      tag <- tagEnsureClass(tag, "font-weight-bold")
    }
  }

  tag
}

#' Background color
#'
#' The `background` utility function applies Bootstrap classes to a tag element
#' to change the element's background color.
#'
#' @param tag A tag element.
#'
#' @param context One of `"primary"`, `"secondary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`, `"light"`, `"dark"`, or `"white"`.
#'
#' @family utilities
#' @export
#' @examples
#' tags$div("light text, dark background") %>%
#'   text("white") %>%
#'   background("dark")
#'
background <- function(tag, context) {
  if (!re(context, "primary|secondary|success|info|warning|danger|light|dark|white")) {
    stop(
      "invalid `background` argument, `context` must be one of ",
      '"primary", "secondary", "success", "info", "warning", "danger", ',
      '"light", "dark", or "white"',
      call. = FALSE
    )
  }
}

#' Float an element
#'
#' The `float` utility function applies Bootstrap float classes to a tag
#' element. These classes cause a tag element to float to the left or right
#' in its parent element. Alternatively, specify `"none"` to remove the
#' element's float. The float utilities are viewport responsive.
#'
#' @param tag A tag element.
#'
#' @param default One of `"left"`, `"right"`, or `"none"` specifying the default
#'   float of the element.
#'
#' @param sm Like `default`, but the float is applied once the viewport is 576
#'   pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the float is applied once the viewport is 768
#'   pixels wide, think tablets.
#'
#' @param lg Like `default`, but the float is applied once the viewport is 992
#'   pixels wide, think desktop.
#'
#' @param xl Like `default`, but the float is applied once the viewport is 1200
#'   pixels wide, think large desktop.
#'
#' @family utilities
#' @export
#' @examples
#'
float <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                  xl = NULL) {
  args <- dropNulls(list(default = default, sm = sm, md = md, lg = lg, xl = xl))

  if (length(float) == 0) {
    stop(
      "invalid `float` arguments, at least one argument must not be NULL",
      call. = FALSE
    )
  }

  classes <- vapply(
    names2(args),
    function(nm) {
      arg <- args[[nm]]

      if (!re(arg, "left|right|none")) {
        stop(
          "invalid `float` argument, `", nm, "` must be one of ",
          '"left", "right", or "none"',
          call. = FALSE
        )
      }

      if (nm == "default") {
        paste0("float-", arg)
      } else {
        paste0("float-", nm, "-", arg)
      }
    },
    character(1)
  )

  tagAddClass(tag, collate(classes))
}

#' Affix elements to top or bottom of page
#'
#' The `affix` utility function applies Bootstrap classes to fix elements to the
#' top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
#' of a page *after* the element is scrolled past. *Important*, the IE11 and
#' Edge browsers do not support the sticky behavior.
#'
#' @param tag A tag element.
#'
#' @param position One of `"top"`, `"bottom"`, or `"sticky"` specifying the
#'   fixed behavior of an element.
#'
#' @family utilities
#' @export
#' @examples
#' tags$div("A simple banner") %>%
#'   width(100) %>%
#'   affix("top")
#'
affix <- function(tag, position) {
  if (!re(position, "top|bottom|sticky", len0 = FALSE)) {
    stop(
      "invalid `affix` argument, `position` must be one of ",
      '"top", "bottom", or "sticky"',
      call. = FALSE
    )
  }

  if (position == "sticky") {
    tagEnsureClass(tag, "sticky-top")
  } else {
    tagEnsureClass(tag, paste0("fixed-", position))
  }
}

#' Align an element
#'
#' The `align` utility function applies Bootstrap classes to change how an
#' *inline* element or *table cell* element is vertically aligned.
#'
#' @param tag A tag object.
#'
#' @param position One of `"top"`, `"middle"`, or `"bottom"` specifying how
#'   the element is vertically aligned.
#'
#' @family utilities
#' @export
#' @examples
#' tags$span() %>%
#'   align("bottom")
#'
align <- function(tag, position) {
  if (!re(position, "top|middle|bottom", len0 = FALSE)) {
    stop(
      "invalid `align` argument, `position` must be one of ",
      '"top", "middle", or "bottom"'
    )
  }

  tagEnsureClass(tag, paste0("align-", position))
}

#' Element display property, inline, block, and more
#'
#' The `display` utility is used to apply Bootstrap classes to adjust a tag
#' element's display property. This can be used to hide an element on small
#' screens or convert an element from inline to block on large screens. Use the
#' `print` argument to change the display property of an element during
#' printing.
#'
#' @param tag A tag element.
#'
#' @param default One of `"inline"`, `"inline-block"`, `"block"`, `"table"`,
#'   `"table-cell"`, `"flex"`, `"inline-flex"`, or `"none"` specifying the
#'   default display property of the element.
#'
#' @param sm Like `default`, but the display property is applied once the
#'   viewport is 576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the display property is applied once the
#'   viewport is 768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the display property is applied once the
#'   viewport is 992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the display property is applied once the
#'   viewport is 1200 pixels wide, think large desktop.
#'
#' @param print Like `default`, but the display property is applied when the
#'   page is printed.
#'
#' @family utilities
#' @export
#' @examples
#' tags$div() %>%
#'   display(default = "none", md = "block")
#'
display <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                    xl = NULL, print = NULL) {
  args <- dropNulls(
    list(default = default, sm = sm, md = md, lg = lg, xl = xl, print = print)
  )

  classes <- responsives(
    prefix = "d",
    values = args,
    possible = c("inline", "inline-block", "block", "flex", "flex-inline", "none")
  )

  tagAddClass(tag, collate(classes))
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
#' @param tag A tag element.
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

  tagAddClass(tag, collate(classes))
}

#' @family utilities
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

  tagAddClass(tag, collate(classes))
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
#' @family utilities
#' @export
#' @examples
#' tags$div() %>%
#'   width(25) %>%
#'   height(100)
#'
#' tags$div() %>%
#'   width(max = 75)
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

  tagAddClass(
    tag,
    collate(
      percentage %??% paste0("w-", percentage),
      max %??% paste0("mw-", max)
    )
  )
}

#' @family utilities
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

  tagAddClass(
    tag,
    collate(
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
