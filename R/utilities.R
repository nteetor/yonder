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
#' @param style One of `"bold"` or `"italics"` specifying the font style of an
#'   element. Defaults to `NULL`, element font style is left as is. Specifying
#'   `"bold"` is equivalent to `weight = "bold"`.
#'
#' @family utilities
#' @rdname text
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

  if (!re(style, "bold|italics")) {
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
    if (style == "italics") {
      tag <- tagEnsureClass(tag, "font-italic")
    } else if (style == "bold") {
      tag <- tagEnsureClass(tag, "font-weight-bold")
    }
  }

  tag
}

.colors <- c(
  "red",
  "purple",
  "indigo",
  "blue",
  "cyan",
  "teal",
  "green",
  "yellow",
  "amber",
  "orange",
  "grey"
)

colorUtility <- function(tag, base, color, tone) {
  if (tagHasClass(tag, "btn-group")) {
    tag$children[[1]] <- lapply(
      tag$children[[1]],
      colorUtility,
      base = base,
      color = color,
      tone = tone
    )

    return(tag)
  }

  if (tagHasClass(tag, "alert")) {
    base <- "alert"
  } else if (tagHasClass(tag, "badge")) {
    base <- "badge"
  } else if (tagHasClass(tag, "btn")) {
    base <- "btn"
  } else if (tagHasClass(tag, "list-group-item")) {
    base <- "list-group-item"
  }

  cregex <- paste0("(", paste(.colors, collapse = "|"), ")")
  tag <- tagDropClass(tag, paste0(base, "-", cregex, "(-[1-9]00)?"))

  tone <- switch(
    as.character(tone),
    `0` = 0,
    `-2` = 900, `-1` = 700,
    `1` = 300, `2` = 100
  )

  tone <- if (tone) paste0("-", tone) else ""

  tag <- tagEnsureClass(tag, paste0(base, "-", color, tone))

  tag
}

#' Chance text, background, or border color
#'
#' The `text`, `background`, and `border` utility functions may be used to
#' change the text, background, or border color of a tag element, respectively.
#'
#' @param tag A tag element.
#'
#' @param color A character string specifying the background color, see details
#'   for all possible values.
#'
#' @param tone An integer between -2 and 2 specifying to use a darker or lighter
#'   tone of `color`. Negative values indicate darker tones and positive values
#'   indicate lighter tones. Defaults to 0, in which case the base color is
#'   unchanged.
#'
#' @family utilities
#' @export
#' @examples
#' tags$div("light text, dark background") %>%
#'   background("grey", -2) %>%
#'   text("yellow", +1)
#'
#' if (interactive()) {
#'   opts <- c(
#'     "red", "purple", "indigo", "blue", "cyan", "teal", "green", "yellow",
#'     "amber", "orange", "brown", "grey"
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           h5("Background"),
#'           selectInput(
#'             id = "bg",
#'             options = opts,
#'             selected = sample(opts, 1)
#'           ),
#'           rangeInput(
#'             id = "bgtone",
#'             min = -2,
#'             max = 2,
#'             default = 0,
#'             step = 1
#'           ) %>%
#'             margins(c(2, 0, 2, 0)),
#'           h5("Border"),
#'           selectInput(
#'             id = "border",
#'             options = opts,
#'             selected = sample(opts, 1)
#'           ),
#'           rangeInput(
#'             id = "bordertone",
#'             min = -2,
#'             max = 2,
#'             default = 0,
#'             step = 1
#'           ) %>%
#'             margins(c(2, 0, 2, 0)),
#'           h5("Text color"),
#'           selectInput(
#'             id = "text",
#'             options = opts,
#'             selected = sample(opts, 1)
#'           ),
#'           rangeInput(
#'             id = "texttone",
#'             min = -2,
#'             max = 2,
#'             default = 0,
#'             step = 1
#'           ) %>%
#'             margins(c(2, 0, 2, 0))
#'         ),
#'         col(
#'           uiOutput("preview") %>%
#'             margins(3) %>%
#'             padding(3)
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$preview <- renderUI({
#'         d3("Hello, world!") %>%
#'           background(input$bg, input$bgtone) %>%
#'           border(input$border, input$bordertone) %>%
#'           text(input$text, input$texttone)
#'       })
#'     }
#'   )
#' }
#'
background <- function(tag, color, tone = 0) {
  if (!(color %in% .colors)) {
    stop(
      "invalid `background` argument, `color` is invalid, see ?background ",
      "details for possible colors",
      call. = FALSE
    )
  }

  if (!(tone %in% -2:2)) {
    stop(
      "invalid `background` argument, `tone` must be one of -2, -1, 0, 1, or 2",
      call. = FALSE
    )
  }

  colorUtility(tag, "bg", color, tone)
}

#' @family utilities
#' @rdname background
#' @export
text <- function(tag, color, tone = 0) {
  if (!(color %in% .colors)) {
    stop(
      "invalid `text` argument, `color` is invalid, see ?background ",
      "details for possible colors",
      call. = FALSE
    )
  }

  if (!(tone %in% -2:2)) {
    stop(
      "invalid `text` argument, `tone` must be one of -2, -1, 0, 1, or 2",
      call. = FALSE
    )
  }

  colorUtility(tag, "text", color, tone)
}

#' @family utilities
#' @rdname background
#' @export
#' @examples
#' tags$h1("Hello, world!") %>%
#'   border("grey", sides = c("top", "bottom"))
#'
#' tags$div() %>%
#'   border("orange")
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkbarInput(
#'             id = NULL,
#'             choices = paste("Choice", 1:4)
#'           ) %>%
#'             background("cyan") %>%
#'             border("indigo")
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
border <- function(tag, color, tone = 0) {
  if (!(color %in% .colors)) {
    stop(
      "invalid `border` argument, `color` is invalid, see ?border ",
      "details for possible colors",
      call. = FALSE
    )
  }

  if (!(tone %in% -2:2)) {
    stop(
      "invalid `border` argument, `tone` must be one of -2, -1, 0, 1, or 2",
      call. = FALSE
    )
  }

  tag <- tagEnsureClass(tag, "border")

  colorUtility(tag, "border", color, tone)
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
#' *inline* or *table cell* element is vertically aligned.
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
height <- function(tag, percentage = NULL, max = NULL) {
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
