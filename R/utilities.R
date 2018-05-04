#' Text font
#'
#' The `font` utility changes the weight and size of an element's text font.
#' Bold fonts are darker and heavier whereas light fonts are thinner. Font
#' size's are changed relative to the current font size.
#'
#' @param tag A tag element.
#'
#' @param size One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
#'   increase a tag element's font size by (e.g. `"2x"` is double the base font
#'   size), defaults to `NULL`, in which case the font size is unchanged.
#'
#' @param weight One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
#'   `"monospace"` specifying the font weight of the element's text, defaults to
#'   `NULL`, in which case the font is unchanged.
#'
#' @family utilities
#' @export
#' @examples
#'
#' span("This and other news") %>%
#'   font(weight = "light")
#'
#' icon("anchor") %>%
#'   font("5x")
#'
#' p("Ipsum Consectetur Nibh Bibendum Ullamcorper") %>%
#'   font("2x", "monospace") %>%
#'   font(weight = "italic")
#'
font <- function(tag, size = NULL, weight = NULL) {
  if (!re(weight, "bold|normal|light|italic|monospace")) {
    stop(
      "invalid `text` argument, `weight` must be one of ",
      '"bold", "normal", "light", "italic", or "monospace"',
      call. = FALSE
    )
  }

  if (!re(size, "([2-9]|10)x")) {
    stop(
      "invalid `size` argument, `size` must be one of ",
      '"2x" through "10px"',
      call. = FALSE
    )
  }

  if (!is.null(size)) {
    size <- paste0("font-size-", size)
    tag <- tagDropClass(tag, "font-size-([2-9]|10)x")
    tag <- tagAddClass(tag, size)
  }

  if (!is.null(weight)) {
    if (re(weight, "bold|normal|light")) {
      weight <- paste0("font-weight-", weight)
    } else {
      weight <- paste0("font-", weight)
    }

    tag <- tagDropClass(tag, "font-(weight-(bold|normal|light)|italic|monospace)")
    tag <- tagAddClass(tag, weight)
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
  "grey",
  "white"
)

colorUtility <- function(tag, base, color, tone) {
  if (tagHasClass(tag, "dull-checkbar-input|dull-radiobar-input")) {
    tag$children[[1]] <- lapply(
      tag$children[[1]],
      colorUtility,
      base = base,
      color = color,
      tone = tone
    )

    return(tag)
  }

  if (tagHasClass(tag, "dull-dropdown-input")) {
    tag$children[[1]] <- colorUtility(
      tag$children[[1]],
      base = base,
      color = color,
      tone = tone
    )

    return(tag)
  }

  cregex <- paste0("(", paste(.colors, collapse = "|"), ")")
  tag <- tagDropClass(tag, paste0(base, "-", cregex, "(-[1-9]00)?"))

  tone <- switch(
    as.character(tone),
    `0` = 0,
    `-2` = 900, `-1` = 700,
    `1` = 300, `2` = 100
  )

  tone <- if (tone && color != "white") paste0("-", tone) else ""

  tag <- tagAddClass(tag, paste0(base, "-", color, tone))

  tag
}

#' Change text, background, or border color
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
#' @details
#'
#' For `text()`, `background()`, and `border()`, the following colors are
#' available,
#'
#' * red
#' * purple
#' * indigo
#' * blue
#' * cyan
#' * teal
#' * green
#' * yellow
#' * amber
#' * orange
#' * grey
#' * white
#'
#' For `background()`, you can also specify the following,
#'
#'  * transparent
#'
#' @family utilities
#' @export
#' @examples
#'
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
  if (color != "transparent" && !(color %in% .colors)) {
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

  if (color == "transparent") {
    base <- "bg"
  } else if (tagHasClass(tag, "alert")) {
    base <- "alert"
  } else if (tagHasClass(tag, "badge")) {
    base <- "badge"
  } else if (tagHasClass(tag, "btn")) {
    base <- "btn"
  } else if (tagHasClass(tag, "list-group-item")) {
    base <- "list-group-item"
  } else {
    base <- "bg"
  }

  colorUtility(tag, base, color, tone)
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
#'
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

  tag <- tagAddClass(tag, "border")

  colorUtility(tag, "border", color, tone)
}

#' Round tag element corners
#'
#' The `rounded` utility function applies Bootstrap classes to an element. The
#' styles are applied by sides, e.g. `"left"` or `"bottom"`. The `"circle"`
#' value heavily rounds all the corners of an element.
#'
#' @param tag A tag element.
#'
#' @param sides One of `"top"`, `"right"`, `"bottom"`, `"left"`, `"circle"`,
#'   `"all"` or `"none"`, defaults to `"all"`, specifying which and how the
#'   the corners of the tag element are rounded.
#'
#' @family utilities
#' @export
#' @examples
#'
rounded <- function(tag, sides = "all") {
  if (!all(re(sides, "top|right|bottom|left|circle|all|none", len0 = FALSE))) {
    stop(
      "invalid `rounded` argument, `sides` must be one of ",
      '"top", "right", "bottom", "left", "circle", "all", or "none"',
      call. = FALSE
    )
  }

  classes <- vapply(
    sides,
    function(s) {
      switch(
        s,
        none = "rounded-0",
        all = "rounded",
        paste0("rounded-", s)
      )
    },
    character(1)
  )

  tagAddClass(tag, classes)
}

#' Add shadows to tag elements
#'
#' The `shadow` utility applies a shadow to a tag element. Elements with a
#' shadow may appear to pop off the page. The material design set of components,
#' used on Android and for Google applications, commonly uses shadowing.
#' Although `"none"` is an allowed `size`, most elements do not have a shadow by
#' default.
#'
#' @param tag A tag element.
#'
#' @param size One of `"none"`, `"small"`, `"regular"`, or `"large"` specifying
#'   the amount of shadow added, defaults to `"regular"`.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = tagList(
#'       navbar(brand = "Navbar") %>%
#'         background("cyan", +1) %>%
#'         shadow("small"),
#'       container(
#'         "Cras mattis consectetur purus sit amet fermentum. Donec sed ",
#'         "odio dui. Lorem ipsum dolor sit amet, consectetur adipiscing ",
#'         "elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'         "venenatis vestibulum."
#'       ) %>%
#'         padding(3)
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
shadow <- function(tag, size = "regular") {
  if (!re(size, "none|small|regular|large", len0 = FALSE)) {
    stop(
      "invalid `shadow()` argument, `size` must be one of ",
      '"none", "small", "regular", or "large"',
      call. = FALSE
    )
  }

  size <- switch(
    size,
    none = "none",
    small = "sm",
    regular = NULL,
    large = "lg"
  )

  tagAddClass(tag, paste0(c("shadow", size), collapse = "-"))
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

  tagAddClass(tag, classes)
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
    tagAddClass(tag, "sticky-top")
  } else {
    tagAddClass(tag, paste0("fixed-", position))
  }
}

#' Align element text
#'
#' The `alignment` utility applies Bootstrap classes to change how an element's
#' text is aligned. Like with [display] or [padding] different text alignments
#' can be applied based on the viewport size.
#'
#' @param tag A tag object.
#'
#' @param default One of `"left"`, `"right"`, `"center"`, or `"justified"`
#'   specifying the default text alignment of the element.
#'
#' @param sm Like `default`, but the text alignment is applied once the viewport
#'   is 576 pixels wide, think phone in landscape mode.
#'
#' @param md Like `default`, but the text alignment is applied once the
#'   viewport is 768 pixels wide, think tablets.
#'
#' @param lg Like `default`, but the text alignment is applied once the
#'   viewport is 992 pixels wide, think desktop.
#'
#' @param xl Like `default`, but the text alignment is applied once the
#'   viewport is 1200 pixels wide, think large desktop.
#'
#' @family utilities
#' @export
#' @examples
#'
#'
alignment <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
                  xl = NULL) {
  args <- dropNulls(
    list(default = default, sm = sm, md = md, lg = lg, xl = xl)
  )

  classes <- responsives(
    prefix = "text",
    values = args,
    possible = c("left", "right", "center", "justify")
  )

  tagAddClass(tag, classes)
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

  tagAddClass(tag, classes)
}

#' Element margins and padding
#'
#' @description
#'
#'These utilities change the padding or margins of a tag. Each argument value
#' may be a single value or a vector of four values. Margins and padding are
#' specified as 0, 1, 2, 3, 4, or 5, where 0 removes all space and 5 adds the most
#' space.
#'
#' Specifying a single value changes the margins or padding along all four sides
#' of `tag`. To apply different margins or padding to each side pass a vector of
#' four values. In this case, the first value adjusts the top, second the right
#' side, third the bottom, and the fourth value adjusts the left side. As a wise
#' help page once said, think "**tr**ou**bl**e" to help remember the order.
#'
#' @param tag A tag element.
#'
#' @param default One of 0, 1, 2, 3, 4, 5 specifying the default margins or
#'   padding to apply. If the margins and padding remain the same across all
#'   viewports then only `default` needs to be specified.
#'
#'   For **margins**, specifying `"auto"` leaves the spacing up to the browser.
#'   For example, you could horizontally center an element for all viewports
#'   by specifying `default = c(1, "auto", 1, "auto")`.
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
#' @details
#'
#' Padding refers to the space between an element and its child element(s).
#'
#' Margins refer to the space outside and around an element.
#'
#' @family utilities
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       lapply(1:5, function(p) {
#'         div("Nunc aliquet, augue nec adipiscing interdum.") %>%
#'           width(25) %>%
#'           margins(1) %>%
#'           padding(p) %>%
#'           border("blue") %>%
#'           rounded() %>%
#'           alignment("center")
#'       })
#'     ) %>%
#'       display("flex") %>%
#'       wrap("wrap"),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
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

  tagAddClass(tag, classes)
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

      if (length(arg) != 4 && length(arg) != 1) {
        stop(
          "invalid `margins` argument, `", nm, "` must be a single value or a ",
          "vector of four values",
          call. = FALSE
        )
      }


      if (!all(re(arg, "[0-5]|auto", len0 = FALSE))) {
        stop(
          "invalid `margins` argument, `", nm, "` value(s) must be ",
          '0, 1, 2, 3, 4, 5, or "auto"',
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

  tagAddClass(tag, classes)
}

#' Tag element width and height
#'
#' Utility functions to change a tag element's width or height. Widths and
#' heights are specified as percentages of the parent object's width or height.
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

  percentage <- if (!is.null(percentage)) paste0("w-", percentage)
  max <- if (!is.null(max)) paste0("mw-", max)

  tagAddClass(tag, c(percentage, max))
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

  percentage <- if (!is.null(percentage)) paste0("h-", percentage)
  max <- if (!is.null(max)) paste0("mh-", max)

  tagAddClass(tag, c(percentage, max))
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
