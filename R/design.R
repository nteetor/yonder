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
  "black",
  "white"
)

colorUtility <- function(tag, base, color) {
  if (tagHasClass(tag, "yonder-checkbar|yonder-radiobar|btn-group|list-group")) {
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

  attachDependencies(tag, yonderDep(), append = TRUE)
}

#' Tag element font
#'
#' The `font()` utility modifies the color, size, weight, case, or alignment of
#' a tag element's text. All arguments default to `NULL`, in which case they are
#' ignored.  For example, `font(.., size = "lg")` increases font size without
#' affecting color, weight, case, or alignment.
#'
#' @param .tag A tag element.
#'
#' @param color One `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
#'   `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`,
#'   `"black"`, or `"white"` specifying the color the tag element's text,
#'   defaults to `NULL`.
#'
#' @param size One of `"xs"`, `"sm"`, `"base"`, `"lg"`, `"xl"` specifying a font
#'   size relative to the default base page font size, defaults to `NULL`.
#'
#' @param weight One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
#'   `"monospace"` specifying the font weight of the element's text, defaults to
#'   `NULL`.
#'
#'@param case One of `"upper"`, `"lower"`, or `"title"` specifying a
#'   transformation of the tag element's text, default to `NULL`.
#'
#' @param align A [responsive] argument. One of `"left"`, `"center"`, `"right"`,
#'   or `"justify"`, specifying the alignment of the tag element's text, defaults
#'   to `NULL`.
#'
#' @family design
#' @export
#' @examples
#'
#' ### Changing text color
#'
#' card(
#'   header = h3("Important!") %>%
#'     font(color = "amber"),
#'   div(
#'     "This is a reminder."
#'   )
#' ) %>%
#'   border(color = "amber")
#'
#' ### Changing font size
#'
#' div(
#'   p("Extra small") %>%
#'     font(size = "xs"),
#'   p("Small") %>%
#'     font(size = "sm"),
#'   p("Medium") %>%
#'     font(size = "base"),
#'   p("Large") %>%
#'     font(size = "lg"),
#'   p("Extra large") %>%
#'     font(size = "xl")
#' )
#'
#' ### Changing font weight
#'
#' # Make an element's text bold, italic, light, or monospace.
#'
#' p("Curabitur lacinia pulvinar nibh.") %>%
#'   font(weight = "bold")
#'
#' p("Proin quam nisl, tincidunt et.") %>%
#'   font(weight = "light")
#'
font <- function(.tag, color = NULL, size = NULL, weight = NULL, case = NULL,
                 align = NULL) {
  if (!re(color, paste(.colors, collapse = "|"))) {
    stop(
      "invalid `font()` argument, `color` unknown ",
      '"', color, '", see ?font for possible values',
      call. = FALSE
    )
  }

  if (!re(size, "xs|sm|base|lg|xl")) {
    stop(
      "invalid `font()` argument, `size` must be one of ",
      '"xs", "sm", "base", "lg", "xl"',
      call. = FALSE
    )
  }

  if (!re(weight, "bold|normal|light|italic|monospace")) {
    stop(
      "invalid `font()` argument, `weight` must be one of ",
      '"bold", "normal", "light", "italic", or "monospace"',
      call. = FALSE
    )
  }

  if (!re(case, "lower|upper|title")) {
    stop(
      "invalid `font()` argument, `case` must be one of ",
      '"lower", "upper", or "title"',
      call. = FALSE
    )
  }

  align <- ensureBreakpoints(align, c("left", "center", "right", "justify"))

  if (!is.null(color)) {
    .tag <- colorUtility(.tag, "text", color)
  }

  if (!is.null(size)) {
    size <- paste0("font-size-", size)
    .tag <- tagDropClass(.tag, "font-size-(xs|sm|base|lg|xl)")
    .tag <- tagAddClass(.tag, size)
  }

  if (!is.null(weight)) {
    if (re(weight, "bold|normal|light")) {
      weight <- paste0("font-weight-", weight)
    } else if (weight == "italic") {
      weight <- paste0("font-", weight)
    } else {
      weight <- paste0("text-", weight)
    }

    .tag <- tagDropClass(.tag, "(font-weight-(bold|normal|light))|font-italic|text-monospace)")
    .tag <- tagAddClass(.tag, weight)
  }

  if (!is.null(case)) {
    if (case == "upper")
      case <- "uppercase"
    else if (case == "lower") {
      case <- "lowercase"
    } else {
      case <- "capitalize"
    }

    .tag <- tagDropClass(.tag, "text-(lowercase|uppercase|capitalize)")
    .tag <- tagAddClass(.tag, case)
  }

  if (length(align)) {
    classes <- createResponsiveClasses(align, "text")
    .tag <- tagAddClass(.tag, classes)
  }

  attachDependencies(.tag, yonderDep())
}

#' Tag element background color
#'
#' Use `background()` to modify the background color of a tag element.
#'
#' @param .tag A tag element.
#'
#' @param color One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
#'   `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`,
#'   `"white"`, or `"transparent"` character string specifying the background
#'   color.
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
      "invalid `background()` argument, unknown `color` ",
      '"', color, '", see ?background for possible colors',
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
  } else if (tagHasClass(.tag, "list-group")) {
    base <- "list-group-item"
  } else {
    base <- "bg"
  }

  colorUtility(.tag, base, color)
}

#' Tag element borders
#'
#' Use `border()` to add or modify tag element borders.
#'
#' @param .tag A tag element.
#'
#' @param color One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
#'   `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`, `"white"`
#'   specifying the border color, defaults to `NULL`.
#'
#' @param sides One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
#'   `"all"` or `"none"` specifying which sides to add a border to, defaults to
#'   `"all"`.
#'
#' @param round One or more of `"top"`, `"right"`, `"bottom"`, `"left"`,
#'   `"circle"`, `"all"`, or `"none"` specifying how to round the border(s) of a
#'   tag element, defaults to `NULL`, in which case the argument is ignored.
#'
#' @family design
#' @export
#' @examples
#'
#' ### Change border color
#'
#' div(
#'   div() %>%
#'     height(3) %>%
#'     width(3) %>%
#'     border("green"),
#'   div() %>%
#'     height(3) %>%
#'     width(3) %>%
#'     border(
#'       color = "blue",
#'       sides = c("left", "right")
#'     )
#' )
#'
#' ### Round sides
#'
#' sides <- c("top", "right", "bottom", "left", "circle", "all")
#'
#' div(
#'   lapply(
#'     sides,
#'     border,
#'     .tag = div() %>%
#'       height(3) %>%
#'       width(3),
#'     color = "black"
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(wrap = TRUE)
#'
border <- function(.tag, color = NULL, sides = "all", round = NULL) {
  if (!re(color, paste(.colors, collapse = "|"))) {
    stop(
      "invalid `border()` argument, unknown `color` ",
      '"', color, '", see ?border for possible colors',
      call. = FALSE
    )
  }

  if (!all(re(sides, "top|right|bottom|left|all|none|circle", len0 = FALSE))) {
    stop(
      "invalid `border()` argument, `sides` must be one of ",
      '"top", "right", "bottom", "left", "all", or "none"',
      call. = FALSE
    )
  }

  if (!all(re(round, "top|right|bottom|left|circle|all|none"))) {
    stop(
      "invalid `border()` argument, `round` must be one of ",
      '"top", "right", "bottom", "left", "circle", "all", or "none"',
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

  if (!is.null(round)) {
    round <- paste0("rounded-", round)

    round[round == "rounded-none"] <- "rounded-0"
    round[round == "rounded-all"] <- "rounded"

    .tag <- tagAddClass(.tag, round)
  }

  attachDependencies(.tag, yonderDep())
}

#' Change color for selected choices
#'
#' Please note this will only have an effect on elements with selectedable
#' choices, e.g. `checkbarInput()`.
#'
#' @param .tag A tag element.
#'
#' @param color One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
#'   `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`, `"white"`
#'   specifying the active color of selected choices.
#'
#' @family design
#' @export
active <- function(.tag, color) {
  if (!(color %in% .colors)) {
    stop(
      "invalid `active()` argument, `color` must be one of ",
      '"red", "purple", "indigo", "blue", "cyan", "teal", "green", "yellow", ',
      '"amber", "orange", "grey", "white"',
      .call = FALSE
    )
  }

  .tag <- tagAddClass(.tag, paste0("active-", color))

  attachDependencies(.tag, yonderDep())
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

  attachDependencies(.tag, yonderDep())
}

#' Tag element float
#'
#' Use `float()` to float an element to the left or right side of its parent
#' element. A newspaper layout is a classic usage where an image is floated with
#' text wrapped around.
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
#'     height(3) %>%
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

  attachDependencies(.tag, yonderDep())
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

  attachDependencies(.tag, yonderDep())
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
#'   height(4) %>%
#'   background("orange") %>%
#'   display(print = "none")  # <-
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

  attachDependencies(.tag, yonderDep())
}

#' Tag element margin and padding
#'
#' Use the `margin()` and `padding()` utilities to change the margin or padding
#' of a tag element.  The margin of a tag element is the space outside and
#' around the tag element, its border, and its content.  The padding of a tag
#' element is the space between the tag element's border and its content or
#' child elements. All arguments default to `NULL`, in which case they are
#' ignored.
#'
#' @param .tag A tag element.
#'
#' @param all,top,right,bottom,left A [responsive] argument.
#'
#'   For **padding()**, one of `0:5` or `"auto"` specifying padding for one or
#'   more sides of the tag element. 0 removes all inner space and 5 adds the
#'   most space.
#'
#'   For **margin()**, one of `-5:5` or `"auto"` specifying a margin for one or
#'   more sides of the tag element. 0 removes all outer space, 5 adds the
#'   most space, and negative values will consume space pulling the element in
#'   that direction.
#'
#' @family design
#' @export
#' @examples
#'
#' ### Centering an element
#'
#' # In most modern browsers you want to horizontally center a tag element using
#' # the flex layout. Alternatively, you can horizontally center an element
#' # using `margin(.., right = "auto", left = "auto")`.
#'
#' div(
#'   "Nam a sapien. Integer placerat tristique nisl.",
#'   style = "height: 100px; width: 200px;"
#' ) %>%
#'   margin(top = 2, r = "auto", b = 2, l = "auto") %>%  # <-
#'   padding(3) %>%
#'   background("indigo")
#'
#' ### Building an inline form
#'
#' # Inline form elements automatically use the flex layout providing you a
#' # means of creating condensed sets of inputs. However, you may need to adjust
#' # the spacing of the form's child elements.
#'
#' # Here is an inline form without any additional spacing applied.
#'
#' formInput(
#'   id = "login",
#'   inline = TRUE,
#'   textInput(
#'     id = "name",
#'     placeholder = "full name"
#'   ),
#'   groupInput(
#'     id = "username",
#'     left = "@",
#'     placeholder = "username"
#'   ),
#'   checkboxInput(
#'     id = "remember",
#'     choice = "Remember me"
#'   )
#' )
#'
#' # Without any adjustments the layout is not great. But, with some styling we
#' # can make this form sparkle. Notice we are also adjusting the default submit
#' # button added to the form input.
#'
#' formInput(
#'   id = "login2",
#'   inline = TRUE,
#'   textInput(
#'     id = "name",
#'     placeholder = "full name"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   groupInput(
#'     id = "username",
#'     left = "@",
#'     placeholder = "username"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   checkboxInput(
#'     id = "remember",
#'     choice = "Remember me"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   submit = submitInput("Log in") %>%
#'     margin(b = 2)  # <-
#' )
#'
padding <- function(.tag, all = NULL, top = NULL, right = NULL, bottom = NULL,
                    left = NULL) {
  possibles <- c(0:5, "auto")

  all <- ensureBreakpoints(all, possibles)
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

  classes <- c(createResponsiveClasses(all, "p"), classes)

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, yonderDep())
}

#' @rdname padding
#' @export
margin <- function(.tag, all = NULL, top = NULL, right = NULL, bottom = NULL,
                   left = NULL) {
  possibles <- c(0:5, "auto", paste0("n", 1:5))

  fixNegative <- function(x) {
    if (x < 0) paste0("n", abs(x)) else x
  }

  all <- ensureBreakpoints(all, possibles, fixNegative)
  top <- ensureBreakpoints(top, possibles, fixNegative)
  right <- ensureBreakpoints(right, possibles, fixNegative)
  bottom <- ensureBreakpoints(bottom, possibles, fixNegative)
  left <- ensureBreakpoints(left, possibles, fixNegative)

  classes <- c(
    createResponsiveClasses(top, "t"),
    createResponsiveClasses(right, "r"),
    createResponsiveClasses(bottom, "b"),
    createResponsiveClasses(left, "l")
  )

  if (!is.null(classes)) {
    classes <- paste0("m", classes)
  }

  classes <- c(createResponsiveClasses(all, "m"), classes)

  .tag <- tagAddClass(.tag, classes)

  attachDependencies(.tag, yonderDep())
}

#' Tag element width
#'
#' Utility function to change a tag element's width. Widths are specified
#' relative to the font size of page (browser default is 16px), relative to
#' their parent element (i.e. 1/2 the width of their parent), or relative to the
#' element's content.
#'
#' @param .tag A tag element.
#'
#' @param size A character string or number specifying the width of the tag
#'   element. Possible values:
#'
#'   An integer between 1 and 20, in which case the width of the element is
#'   relative to the font size of the page.
#'
#'   `"1/2"`, `"1/3"`, `"2/3"`, `"1/4"`, `"3/4"`, `"1/5"`, `"2/5"`, `"3/5"`,
#'   `"4/5"`, or `"full"`, in which case the element's width is a percentage of
#'   its parent's width. The height of the parent element must be specified for
#'   percentage widths to work. Percentages do not account for margins or
#'   padding and may cause an element to extend beyond its parent.
#'
#'   `"auto"`, in which case the element's width is determined by the browser.
#'   The browser will take into account the width, padding, margins, and border
#'   of the tag element's parent to keep the element from extending beyond its
#'   parent.
#'
#' @family design
#' @export
#' @examples
#'
#' ### Numeric values
#'
#' # When specifying a numeric value the width of the element is relative to the
#' # default font size of the page.
#'
#' div(
#'   lapply(
#'     1:20,
#'     width,
#'     .tag = div() %>%
#'       border("black") %>%
#'       height(4)
#'   )
#' ) %>%
#'   flex(
#'     direction = "column",
#'     justify = "between"
#'   )
#'
#' ### Fractional values
#'
#' # When specifying width as a fraction the element's width is a percentage of
#' # its parent's width.
#'
#' div() %>%
#'   margin(b = 3) %>%
#'   background("red") %>%
#'   height(5) %>%
#'   width("1/3")  # <-
#'
width <- function(.tag, size) {
  .tag <- tagAddClass(.tag, paste0("w-", size))

  attachDependencies(.tag, yonderDep())
}

#' Tag element height
#'
#' Utility function to change a tag element's height. Height is specified
#' relative to the font size of page (browser default is 16px), relative to
#' their parent element, or relative to the element's content.
#'
#' @param .tag A tag element.
#'
#' @param size A character string or number specifying the height of the tag
#'   element. Possible values:
#'
#'   An integer between 1 and 20, in which case the height of the element is
#'   relative to the font size of the page.
#'
#'   `"full"`, in which case the element's height is a percentage of its
#'   parent's height. The height of the parent element must also be specified.
#'   Percentages do not account for margins or padding and may cause an element
#'   to extend beyond its parent.
#'
#'   `"auto"`, in which case the element's height is determined by the browser.
#'   The browser will take into account the height, padding, margins, and border
#'   of the tag element's parent to keep the element from extending beyond its
#'   parent.
#'
#'   `"screen"`, in which case the element's height is determined by the height of
#'   the viewport.
#'
#' @family design
#' @export
#' @examples
#'
#' ### Numeric values
#'
#' div(
#'   lapply(
#'     seq(2, 20, by = 2),
#'     function(h) {
#'       div(h) %>%
#'         width(2) %>%
#'         height(h) %>%  # <-
#'         padding(l = 1) %>%
#'         border("black")
#'     }
#'   )
#' ) %>%
#'   display("flex") %>%
#'   flex(justify = "between")
#'
height <- function(.tag, size) {
  .tag <- tagAddClass(.tag, paste0("h-", size))

  attachDependencies(.tag, yonderDep())
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
#'   height(20) %>%
#'   border() %>%
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

  attachDependencies(.tag, yonderDep())
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
