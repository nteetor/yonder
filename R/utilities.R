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

colorUtility <- function(tag, base, color) {
  if (tagHasClass(tag, "dull-checkbar-input|dull-radiobar-input")) {
    tag$children[[1]] <- lapply(
      tag$children[[1]],
      colorUtility,
      base = base,
      color = color
    )

    return(tag)
  }

  if (tagHasClass(tag, "dull-dropdown-input")) {
    tag$children[[1]] <- colorUtility(
      tag$children[[1]],
      base = base,
      color = color
    )

    return(tag)
  }

  tag <- tagDropClass(tag, sprintf("%s-(%s)", base, paste(.colors, collapse = "|")))
  tag <- tagAddClass(tag, paste0(base, "-", color))

  tag
}

#' Tag element font
#'
#' The `font()` utility may be used to change the color, size, or weight of a
#' tag element's text font. Font size's are changed relative to the base font
#' size of the web page.
#'
#' @param tag A tag element.
#'
#' @param color A character string specifying the text color of the tag element,
#'   defaults to `NULL` in which case the text color is unchanged.
#'
#' @param size One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
#'   increase a tag element's font size by (e.g. `"2x"` is double the base font
#'   size), defaults to `NULL`, in which case the font size is unchanged.
#'
#' @param weight One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
#'   `"monospace"` specifying the font weight of the element's text, defaults to
#'   `NULL`, in which case the font weight is unchanged.
#'
#' @details
#'
#' The possible font colors are,
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
#' * body (this "color" sets the tag element's font color to the default body
#'   color)
#' * grey
#' * white
#'
#' @family utilities
#' @export
#' @examples
#'
#' span("This and other news") %>%
#'   font(weight = "light")
#'
#'
#' icon("anchor") %>%
#'   font(color = "blue", size = "5x")
#'
#'
#' p("Ipsum Consectetur Nibh Bibendum Ullamcorper") %>%
#'   font(size = "2x", weight = "italic")
#'
#'
#' if (interactive()) {
#'   colors <- c(
#'     "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'     "yellow", "amber", "orange", "body", "grey", "white"
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       lapply(
#'         head(colors, -1),
#'         font,
#'         tag = div("Pellentesque tristique imperdiet tortor.") %>%
#'           padding(5)
#'       ),
#'       div("Pellentesque tristique imperdiet tortor.") %>%
#'         padding(5) %>%
#'         background("grey") %>%
#'         font(tail(colors, 1))
#'     ) %>%
#'       display(flex = TRUE) %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
font <- function(tag, color = NULL, size = NULL, weight = NULL) {
  if (color != "body" && !re(color, paste(.colors, collapse = "|"))) {
    stop(
      "invalid `text` argument, `color` is invalid, see ?background ",
      "details for possible colors",
      call. = FALSE
    )
  }

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

  if (!is.null(color)) {
    tag <- colorUtility(tag, "text", color)
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

#' Tag element background color
#'
#' Use `background()` to change the background color of a tag element.
#'
#' @param tag A tag element.
#'
#' @param color A character string specifying the background color, see below
#'   for all possible values.
#'
#' @details
#'
#' The possible background colors are,
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
#' * transparent
#'
#' @family utilities
#' @export
#' @examples
#'
#' div("Nullam eu ante vel est convallis dignissim.") %>%
#'   background("grey")
#'
#'
#' checkbarInput(
#'   id = NULL,
#'   choices = c(
#'     "Nunc rutrum turpis sed pede.",
#'     "Etiam vel neque.",
#'     "Lorem ipsum dolor sit amet."
#'   )
#' ) %>%
#'   background("cyan")
#'
#'
#' if (interactive()) {
#'   colors <- c(
#'     "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'     "yellow", "amber", "orange", "grey", "white"
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       lapply(
#'         colors,
#'         background,
#'         tag = div() %>%
#'           padding(5) %>%
#'           margins(2)
#'       )
#'     ) %>%
#'       display(flex = TRUE) %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
background <- function(tag, color) {
  if (!(color %in% c(.colors, "transparent"))) {
    stop(
      "invalid `background` argument, `color` is invalid, see ?background ",
      "details for possible colors",
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

  colorUtility(tag, base, color)
}

#' Tag element borders
#'
#' Use `border()` to add borders to a tag element or change the color of a tag
#' element's border.
#'
#' @param tag A tag element.
#'
#' @param color A character string specifying the border color, defaults to
#'   `NULL`, in which case the browser default is used. See below for possible
#'   border colors.
#'
#' @param sides One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
#'   `"all"` or `"none"` specifying which sides to add a border to, defaults to
#'   `"all"`.
#'
#' @details
#'
#' The following border colors are available,
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
#' @family utilities
#' @export
#' @examples
#'
#' h1("") %>%
#'   border("grey")
#'
#'
#' div("Vivamus id enim.") %>%
#'   border("orange")
#'
#' if (interactive()) {
#'   colors <- c(
#'     "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'     "yellow", "amber", "orange", "grey", "white"
#'   )
#'
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       lapply(
#'         colors,
#'         border,
#'         tag = div() %>%
#'           padding(5) %>%
#'           margins(2)
#'       )
#'     ) %>%
#'       display(flex = TRUE) %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
border <- function(tag, color = NULL, sides = "all") {
  if (!re(color, paste(color, collapse = "|"))) {
    stop(
      "invalid `border()` argument, `color` is invalid, see ?border ",
      "details for possible colors",
      call. = FALSE
    )
  }

  if (!all(re(sides, "top|right|bottom|left|all|none", len0 = FALSE))) {
    stop(
      "invalid `border()` argument, `sides` must be one of ",
      '"top", "right", "bottom", "left", "all", or "none"',
      call. = FALSE
    )
  }

  if (!is.null(color)) {
    tag <- colorUtility(tag, "border", color)
  }

  if ("all" %in% sides) {
    tag <- tagAddClass(tag, "border")
  } else if ("none" %in% sides) {
    tag <- tagAddClass(tag, "border-0")
  } else {
    tag <- tagAddClass(tag, sprintf("border-%s", sides))
  }

  tag
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
#'         background("cyan") %>%
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

#' Tag element text alignment
#'
#' The `text()` utility applies Bootstrap classes to change how an element's
#' text is aligned. Like with [display()] or [padding()] different text alignments
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       p("Text always aligned center. Resize your browser window to see these",
#'         "examples in action") %>%
#'         text("center"),
#'       p("Text centered on screens >= large, left aligned by default") %>%
#'         text("left", lg = "center"),
#'       p("Text aligned left on screens >= medium, right aligned by default") %>%
#'         text("right", md = "left"),
#'       p("Text aligned left on screens >= medium, centered for >= small, justified",
#'         "for mobile") %>%
#'         text("justify", sm = "center", md = "left")
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
text <- function(tag, default = NULL, sm = NULL, md = NULL, lg = NULL,
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

#' Tag element display
#'
#' Use the `display()` utility to adjust a tag element's display property. This
#' allows you to hide elements on small screens or convert elements from inline
#' to block on large screens.
#'
#' @param tag A tag element.
#'
#' @param inline ..
#'
#' @param block ..
#'
#' @param flex ..
#'
#' @param none ..
#'
#' @family utilities
#' @export
#' @examples
#'
#' div() %>%
#'   display(none = TRUE, block = c(md = TRUE))
#'
display <- function(tag, inline = NULL, block = NULL, flex = NULL,
                    none = NULL) {
  inline <- ensureBreakpoints(inline, TRUE)
  block <- ensureBreakpoints(block, TRUE)
  flex <- ensureBreakpoints(flex, TRUE)
  none <- ensureBreakpoints(none, TRUE)

  checkDuplicateBreakpoints(block, flex, none)

  if (length(inline) && (length(block) || length(flex))) {
    for (breakpoint in names2(inline)) {
      if (isTRUE(inline[[breakpoint]])) {
        if (isTRUE(block[[breakpoint]])) {
          block[[breakpoint]] <- "inline-block"
          inline[[breakpoint]] <- NULL
        }

        if (isTRUE(flex[[breakpoint]])) {
          flex[[breakpoint]] <- "inline-flex"
          inline[[breakpoint]] <- NULL
        }
      }
    }
  }

  if (length(inline)) {
    inline[vapply(inline, isTRUE, logical(1))] <- "inline"
  }

  if (length(block)) {
    block[vapply(block, isTRUE, logical(1))] <- "block"
  }

  if (length(flex)) {
    flex[vapply(flex, isTRUE, logical(1))] <- "flex"
  }

  if (length(none)) {
    none[vapply(none, isTRUE, logical(1))] <- "none"
  }

  if (length(print)) {
    print[vapply(print, isTRUE, logical(1))] <- "print"
  }

  classes <- c(
    createResponsiveClasses(inline, "d"),
    createResponsiveClasses(block, "d"),
    createResponsiveClasses(flex, "d"),
    createResponsiveClasses(none, "d")
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
#'       lapply(
#'         1:5,
#'         padding,
#'         tag = div("Nunc aliquet, augue nec") %>%
#'           width(25) %>%
#'           margins(1) %>%
#'           border("blue") %>%
#'           rounded() %>%
#'           text("center")
#'       )
#'     ) %>%
#'       display(flex = TRUE) %>%
#'       flex(wrap = TRUE),
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
#' @param tag A tag element.
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
