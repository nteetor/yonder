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
  if (tagHasClass(tag, "yonder-checkbar|yonder-radiobar")) {
    tag$children[[1]] <- lapply(
      tag$children[[1]],
      colorUtility,
      base = base,
      color = color
    )

    return(tag)
  }

  if (tagHasClass(tag, "dropdown")) {
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
#' @param .tag A tag element.
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
#' @param align A [responsive] argument. One of `"left"`, `"center"`, `"right"`,
#'   or `"justify"`.
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
#'       center = TRUE,
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
#'       display("flex") %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
font <- function(.tag, color = NULL, size = NULL, weight = NULL, align = NULL) {
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

  align <- ensureBreakpoints(align, c("left", "center", "right", "justify"))

  if (!is.null(color)) {
    .tag <- colorUtility(.tag, "text", color)
  }

  if (!is.null(size)) {
    size <- paste0("font-size-", size)
    .tag <- tagDropClass(.tag, "font-size-([2-9]|10)x")
    .tag <- tagAddClass(.tag, size)
  }

  if (!is.null(weight)) {
    if (re(weight, "bold|normal|light")) {
      weight <- paste0("font-weight-", weight)
    } else {
      weight <- paste0("font-", weight)
    }

    .tag <- tagDropClass(.tag, "font-(weight-(bold|normal|light)|italic|monospace)")
    .tag <- tagAddClass(.tag, weight)
  }

  if (length(align)) {
    classes <- createResponsiveClasses(align, "text")
    .tag <- tagAddClass(.tag, classes)
  }

  .tag
}

#' Tag element background color
#'
#' Use `background()` to change the background color of a tag element.
#'
#' @param .tag A tag element.
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
#'       center = TRUE,
#'       lapply(
#'         colors,
#'         background,
#'         tag = div() %>%
#'           padding(5) %>%
#'           margin(2)
#'       )
#'     ) %>%
#'       display("flex") %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
background <- function(.tag, color) {
  if (!(color %in% c(.colors, "transparent"))) {
    stop(
      "invalid `background` argument, `color` is invalid, see ?background ",
      "details for possible colors",
      call. = FALSE
    )
  }

  if (color == "transparent") {
    base <- "bg"
  } else if (tagHasClass(.tag, "alert")) {
    base <- "alert"
  } else if (tagHasClass(.tag, "badge")) {
    base <- "badge"
  } else if (tagHasClass(.tag, "yonder-radiobar|yonder-checkbar")) {
    base <- "btn"
  } else if (tagHasClass(.tag, "btn")) {
    base <- "btn"
  } else if (tagHasClass(.tag, "list-group-item")) {
    base <- "list-group-item"
  } else {
    base <- "bg"
  }

  colorUtility(.tag, base, color)
}

#' Tag element borders
#'
#' Use `border()` to add borders to a tag element or change the color of a tag
#' element's border.
#'
#' @param .tag A tag element.
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
#'       center = TRUE,
#'       lapply(
#'         colors,
#'         border,
#'         tag = div() %>%
#'           padding(5) %>%
#'           margin(2)
#'       )
#'     ) %>%
#'       display("flex") %>%
#'       flex(wrap = TRUE),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
border <- function(.tag, color = NULL, sides = "all") {
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
    .tag <- colorUtility(.tag, "border", color)
  }

  if ("all" %in% sides) {
    .tag <- tagAddClass(.tag, "border")
  } else if ("none" %in% sides) {
    .tag <- tagAddClass(.tag, "border-0")
  } else {
    .tag <- tagAddClass(.tag, sprintf("border-%s", sides))
  }

  .tag
}

#' Round tag element corners
#'
#' The `rounded` utility function applies Bootstrap classes to an element. The
#' styles are applied by sides, e.g. `"left"` or `"bottom"`. The `"circle"`
#' value heavily rounds all the corners of an element.
#'
#' @param .tag A tag element.
#'
#' @param sides One of `"top"`, `"right"`, `"bottom"`, `"left"`, `"circle"`,
#'   `"all"` or `"none"`, defaults to `"all"`, specifying which and how the
#'   the corners of the tag element are rounded.
#'
#' @family utilities
#' @export
#' @examples
#'
rounded <- function(.tag, sides = "all") {
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

  tagAddClass(.tag, classes)
}

#' Add shadows to tag elements
#'
#' The `shadow` utility applies a shadow to a tag element. Elements with a
#' shadow may appear to pop off the page. The material design set of components,
#' used on Android and for Google applications, commonly uses shadowing.
#' Although `"none"` is an allowed `size`, most elements do not have a shadow by
#' default.
#'
#' @param .tag A tag element.
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
shadow <- function(.tag, size = "regular") {
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

  tagAddClass(.tag, paste0(c("shadow", size), collapse = "-"))
}

#' Tag element float
#'
#' Use `float()` to float an element to the left or right side of its parent
#' element. A classic example using floats is a newspaper layout where text is
#' wrapped around a picture.
#'
#' @param .tag A tag element.
#'
#' @param side A [responsive] argument. One of `"left"` or `"right"` specifying
#'   the side to float the element.
#'
#' @section Newspaper layout:
#'
#' ```
#' div(
#'   icon("table-tennis") %>%
#'     font(size = "5x") %>%
#'     padding(2) %>%
#'     float("left"),
#'   p(
#'     "Fusce commodo. Nullam tempus. Nunc rutrum turpis sed pede.",
#'     "Phasellus lacus.  Cras placerat accumsan nulla.",
#'     "Fusce sagittis, libero non molestie mollis, ",
#'     "magna orci ultrices dolor, at vulputate neque nulla lacinia eros."
#'   ),
#'   p(
#'     "Nulla facilisis, risus a rhoncus fermentum, tellus tellus",
#'     "lacinia purus, et dictum nunc justo sit amet elit."
#'   ),
#'   p(
#'     "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
#'     "Aliquam posuere.",
#'     "Sed id ligula quis est convallis tempor."
#'   )
#' )
#' ```
#'
#' @family utilities
#' @export
#' @examples
#'
float <- function(.tag, side) {
  side <- ensureBreakpoints(side, c("left", "right"))

  classes <- createResponsiveClasses(side, "float")

  tagAddClass(.tag, classes)
}

#' Affix elements to top or bottom of page
#'
#' The `affix` utility function applies Bootstrap classes to fix elements to the
#' top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
#' of a page *after* the element is scrolled past. *Important*, the IE11 and
#' Edge browsers do not support the sticky behavior.
#'
#' @param .tag A tag element.
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
affix <- function(.tag, position) {
  if (!re(position, "top|bottom|sticky", len0 = FALSE)) {
    stop(
      "invalid `affix` argument, `position` must be one of ",
      '"top", "bottom", or "sticky"',
      call. = FALSE
    )
  }

  if (position == "sticky") {
    tagAddClass(.tag, "sticky-top")
  } else {
    tagAddClass(.tag, paste0("fixed-", position))
  }
}

#' Tag element display
#'
#' Use the `display()` utility to adjust how a tag element is rendered. All
#' arguments are responsive allowing you to hide elements on small screens or
#' convert elements from inline to block on large screens. Most of the time
#' you will use the `render` argument. However if you want to control how an
#' element appears (or does not appear) when the page is printed use the `print`
#' argument.
#'
#' @param .tag A tag element.
#'
#' @param render,print A [responsive] argument. One of `"inline"`, `"block"`,
#'   `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`, defaults to
#'   `NULL`.
#'
#' @family utilities
#' @export
#' @examples
#'
#' display(div(), render = c(xs = "none", md = "block"))
#'
#' display(div(), render = c(xs = "inline", sm = "block"))
#'
#' display(div(), print = "none")
#'
display <- function(.tag, render = NULL, print = NULL) {
  possibles <- c("inline", "block", "inline-block", "flex", "inline-flex", "none")

  render <- ensureBreakpoints(render, possibles)
  print <- ensureBreakpoints(print, possibles)

  classes <- c(
    createResponsiveClasses(render, "d"),
    createResponsiveClasses(print, "d-print")
  )

  tagAddClass(.tag, classes)
}

#' Tag element margin and padding
#'
#' @description
#'
#' Use the `margin()` and `padding()` utilities to change the margin or padding
#' of a tag element.  The margin of a tag element is the space outside and
#' around the tag element, its border, and its content.  The padding of a tag
#' element is the space between the tag element's border and its content or
#' child elements.
#'
#' @param .tag A tag element.
#'
#' @param top A [responsive] argument. One of `0:5` or `"auto"`. 0 removes all
#'   space and 5 adds the most space.
#'
#'   If an **unnamed** value is passed as `top` `margin()` and `padding()` will
#'   apply the spcified spacing to **all** sides.
#'
#' @param right,bottom,left A [responsive] argument. One of `0:5` or `"auto"`. 0
#'   removes all space and 5 adds the most space.
#'
#' @section Centering an element:
#'
#' In most modern browsers you want to horizontally center a tag element
#' using the [flex] layout. Alternatively, you can horizontally center an element
#' using `margin(<TAG>, right = "auto", left = "auto")`.
#'
#' ```
#' div("Nam a sapien. Integer placerat tristique nisl.") %>%
#'   width(50) %>%
#'   height(25) %>%
#'   margin(top = 2, r = "auto", b = 2, l = "auto") %>%
#'   padding(3) %>%
#'   background("amber")
#' )
#' ```
#'
#' @section Building an inline form:
#'
#' Inline form elements automatically use of the flex layout providing you a
#' means of creating condensed sets of inputs. However you may need to adjust
#' the spacing of the form's child elements.
#'
#' Here is an inline form without any additional spacing applied.
#'
#' ```
#' formInput(
#'   id = NULL,
#'   inline = TRUE,
#'   textInput(id = NULL, placeholder = "Sam Vimes"),
#'   groupInput(id = NULL, right = "@", placeholder = "Username"),
#'   checkboxInput(id = NULL, choice = "Remember me")
#'   )
#' )
#' ```
#'
#' Not great. But, with some styling we can make this form sparkle. Notice
#' we are also adjusting the default submit button added to the form input.
#'
#' ```
#' formInput(
#'   id = NULL,
#'   inline = TRUE,
#'   textInput(id = NULL, placeholder = "Sam Vimes") %>%
#'     margin(r = c(sm = 2), b = 2),
#'   groupInput(id = NULL, right = "@", placeholder = "Username") %>%
#'     margin(r = c(sm = 2), b = 2),
#'   checkboxInput(id = NULL, choice = "Remember me") %>%
#'     margin(r = c(sm = 2), b = 2),
#'   submit = submitInput() %>%
#'     margin(b = 2)
#' )
#' ```
#'
#' Now we're cooking with gas!
#'
#' @family utilities
#' @export
#' @examples
#'
#' padding(div(), c(xs = 0, sm = 2, lg = 4))
#'
#' margin(div(), right = c(md = "auto"))
#'
#' margin(div(), bottom = 3, left = 1)
#'
#'
#' div(
#'   div() %>%
#'     margin(4) %>%
#'     padding(4) %>%
#'     background("grey") %>%
#'     border()
#' )
#'
padding <- function(.tag, top = NULL, right = NULL, bottom = NULL, left = NULL) {
  possibles <- c(0:5, "auto")
  this <- sys.call()

  # all padding case
  if (all(re(names2(this), "\\.tag|")) && length(this) == 3) {
    all <- tryCatch(
      ensureBreakpoints(top, possibles),
      error = function(e) stop(
        "invalid call to `padding()`, unexpected argument value ", top,
        call. = FALSE
      )
    )

    classes <- createResponsiveClasses(all, "p")
    return(tagAddClass(.tag, classes))
  }

  top <- ensureBreakpoints(top, possibles)
  right <- ensureBreakpoints(right, possibles)
  bottom <- ensureBreakpoints(bottom, possibles)
  left <- ensureBreakpoints(left, possibles)

  classes <- c(
    createResponsiveClasses(top, "t"),
    createResponsiveClasses(right, "r"),
    createResponsiveClasses(bottom, "b"),
    createResponsiveClasses(left, "l")
  )

  if (!is.null(classes)) {
    classes <- paste0("p", classes)
  }

  tagAddClass(.tag, classes)
}

#' @family utilities
#' @rdname padding
#' @export
margin <- function(.tag, top = NULL, right = NULL, bottom = NULL, left = NULL) {
  possibles <- c(0:5, "auto")
  this <- sys.call()

  # all sides case
  if (all(re(names2(this), "\\.tag|")) && length(this) == 3) {
    all <- tryCatch(
      ensureBreakpoints(top, possibles),
      error = function(e) stop(
        "invalid call to `margin()`, unexpected argument value ", top,
        call. = FALSE
      )
    )
    classes <- createResponsiveClasses(all, "m")
    return(tagAddClass(.tag, classes))
  }

  top <- ensureBreakpoints(top, possibles)
  right <- ensureBreakpoints(right, possibles)
  bottom <- ensureBreakpoints(bottom, possibles)
  left <- ensureBreakpoints(left, possibles)

  classes <- c(
    createResponsiveClasses(top, "t"),
    createResponsiveClasses(right, "r"),
    createResponsiveClasses(bottom, "b"),
    createResponsiveClasses(left, "l")
  )

  if (!is.null(classes)) {
    classes <- paste0("m", classes)
  }

  tagAddClass(.tag, classes)
}

#' Tag element width and height
#'
#' Utility functions to change a tag element's width or height. Widths and
#' heights are specified as percentages of the parent object's width or height.
#'
#' @param .tag A tag element.
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
#'
#' tags$div() %>%
#'   width(25) %>%
#'   height(100)
#'
#' tags$div() %>%
#'   width(max = 75)
#'
width <- function(.tag, percentage = NULL, max = NULL) {
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

  tagAddClass(.tag, c(percentage, max))
}

#' @family utilities
#' @rdname width
#' @export
height <- function(.tag, percentage = NULL, max = NULL) {
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

  tagAddClass(.tag, c(percentage, max))
}

#' Vertical and horizontal scroll
#'
#' Many of the applications you build depsite a complex layout will still fit
#' onto a single page. To help scroll long content along side shorter content
#' use the `scroll()` utility function.
#'
#' @param .tag A tag element.
#'
#' @param direction One of `"x"` or `"y"` specifying which direction to scroll
#'   the tag's content, defaults to `"y"`, in which case horizontal scroll is
#'   applied.
#'
#' @examples
#'
#' div(
#'   lapply(
#'     rep("Integer placerat tristique nisl.", 20),
#'     p
#'   )
#' ) %>%
#'   height(25) %>%
#'   scroll()
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
#'           width = 3,
#'           card(
#'             listGroupThruput(
#'               id = NULL,
#'               lapply(
#'                 rep("In id erat non orci commodo lobortis.", 30),
#'                 listGroupItem
#'               )
#'             )
#'           ) %>%
#'             height(100) %>%
#'             scroll()
#'         ),
#'         column(
#'
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'
#'     }
#'   )
#' }
#'
scroll <- function(.tag, direction = "y") {
  if (length(direction) != 1 || !is.character(direction)) {
    stop(
      "invalid `scroll()` argument, `direction` must be a single character string",
      call. = FALSE
    )
  }

  if (direction != "x" && direction != "y") {
    stop(
      'invalid `scroll()` arugment, `direction` must be one of "x" or "y"',
      call. = FALSE
    )
  }

  tagAddClass(.tag, paste0("scroll-", direction))
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
