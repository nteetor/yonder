#' Design
#'
#' Easily modify tag elements with design utility functions.
#'
#' @noRd
#' @name index
#' @family design
#' @layout index
NULL

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
  if (tagHasClass(tag, "yonder-checkbar|yonder-radiobar") ||
        tagHasClass(tag, "btn-group")) {
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

  attachDependencies(tag, c(yonderDep(), bootstrapDep()), append = TRUE)
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
#' @family design
#' @export
#' @examples
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "body", "grey", "white"
#' )
#'
#' div(
#'   lapply(
#'     head(colors, -1),
#'     font,
#'     .tag = div("Pellentesque tristique imperdiet tortor.") %>%
#'       padding(5)
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
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

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Modifying input elements
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
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey", "white"
#' )
#'
#' div(
#'   lapply(
#'     colors,
#'     background,
#'     .tag = div() %>%
#'       padding(5) %>%
#'       margin(2)
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
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
  } else if (tagHasClass(.tag, "yonder-radiobar|yonder-checkbar") ||
               tagHasClass(.tag, "btn-group") ||
               tagHasClass(.tag, "btn")) {
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
#' @family design
#' @export
#' @examples
#'
#' ### Possible colors
#'
#' colors <- c(
#'   "red", "purple", "indigo", "blue", "cyan", "teal", "green",
#'   "yellow", "amber", "orange", "grey", "white"
#' )
#'
#' div(
#'   lapply(
#'     colors,
#'     border,
#'     .tag = div() %>%
#'       padding(5) %>%
#'       margin(2)
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
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

  if ("all" %in% sides) {
    .tag <- tagAddClass(.tag, "border")
  } else if ("none" %in% sides) {
    .tag <- tagAddClass(.tag, "border-0")
  } else {
    .tag <- tagAddClass(.tag, sprintf("border-%s", sides))
  }

  if (!is.null(color)) {
    .tag <- colorUtility(.tag, "border", color)
  }

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
}

#' Round tag element borders
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
#' @family design
#' @export
#' @examples
#'
#' ### Different sides
#'
#' sides <- c("top", "right", "bottom", "left", "circle", "all")
#'
#' div(
#'   lapply(
#'     sides,
#'     rounded,
#'     .tag = div() %>%
#'       padding(5) %>%
#'       margin(2) %>%
#'       border("indigo")
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
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

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Styling a navbar
#'
#' div(
#'   navbar(brand = "Navbar") %>%
#'     background("cyan") %>%
#'     shadow("small") %>%
#'     margin(bottom = 3),
#'   p(
#'     "Cras mattis consectetur purus sit amet fermentum. Donec sed ",
#'     "odio dui. Lorem ipsum dolor sit amet, consectetur adipiscing ",
#'     "elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'     "venenatis vestibulum."
#'   )
#' )
#'
#' ### Different shadows
#'
#' div(
#'   lapply(
#'     c("small", "regular", "large"),
#'     shadow,
#'     .tag = div() %>%
#'       padding(5) %>%
#'       margin(2)
#'   )
#' ) %>%
#'   display("flex")
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

  .tag <- tagAddClass(.tag, paste0(c("shadow", size), collapse = "-"))

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Newspaper layout
#'
#' div(
#'   div() %>%
#'     padding(5) %>%
#'     margin(right = 2) %>%
#'     background("amber") %>%
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
#'
float <- function(.tag, side) {
  side <- ensureBreakpoints(side, c("left", "right"))

  classes <- createResponsiveClasses(side, "float")

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### See top of page
#'
#' div(
#'   span("I'm up here!") %>%
#'     padding(left = 3, right = 3) %>%
#'     background("teal")
#' ) %>%
#'   display("flex") %>%
#'   flex(justify = "center") %>%
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
    .tag <- tagAddClass(.tag, "sticky-top")
  } else {
    .tag <- tagAddClass(.tag, paste0("fixed-", position))
  }

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Using flexbox
#'
#' # When using `flex()` be sure to set the display, too.
#'
#' div(
#'   lapply(
#'     1:5,
#'     function(i) {
#'       div() %>%
#'         padding(5) %>%
#'         margin(top = c(xs = 2), bottom = c(xs = 2)) %>%
#'         background("blue")
#'     }
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(
#'     direction = c(xs = "column", sm = "row"),
#'     justify = c(sm = "around")
#'   )
#'
#' ### Printing pages
#'
#' # This element is not shown when the page is printed.
#'
#' div() %>%
#'   margin(5) %>%
#'   background("orange") %>%
#'   display(print = "none")
#'
display <- function(.tag, render = NULL, print = NULL) {
  possibles <- c("inline", "block", "inline-block", "flex", "inline-flex", "none")

  render <- ensureBreakpoints(render, possibles)
  print <- ensureBreakpoints(print, possibles)

  classes <- c(
    createResponsiveClasses(render, "d"),
    createResponsiveClasses(print, "d-print")
  )

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Getting started
#'
#' padding(div(), c(xs = 0, sm = 2, lg = 4))
#'
#' margin(div(), right = c(md = "auto"))
#'
#' margin(div(), bottom = 3, left = 1)
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

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
}

#' @family design
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

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#' @family design
#' @export
#' @examples
#'
#' ### Percentage based widths and heights
#'
#' # These percentages are based on the size of the parent element.
#'
#' div(
#'   style = "height: 50px; width: 120px;",
#'   div() %>%
#'     width(25) %>%
#'     height(100) %>%
#'     background("yellow")
#' ) %>%
#'   border("black")
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

  .tag <- tagAddClass(.tag, c(percentage, max))

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
}

#' @family design
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

  .tag <- tagAddClass(.tag, c(percentage, max))

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
#'   the tag's content, defaults to `"y"`, in which case vertical scroll is
#'   applied.
#'
#' @family design
#' @export
#' @examples
#'
#' ### A simple scroll
#'
#' div(
#'   lapply(
#'     rep("Integer placerat tristique nisl.", 20),
#'     p
#'   )
#' ) %>%
#'   height(50) %>%
#'   scroll()
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

  .tag <- tagAddClass(.tag, paste0("scroll-", direction))

  attachDependencies(.tag, c(yonderDep(), bootstrapDep()))
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
