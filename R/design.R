theme_colors <- c(
  "primary",
  "secondary",
  "success",
  "info",
  "warning",
  "danger",
  "light",
  "dark"
)

param_color <- function(what) {
  q_start <- '`"'
  q_end <- '"`'

  paste(
    "@param color One of",
    paste0(q_start, utils::head(theme_colors, -1), q_end, collapse = ", "),
    "or",
    paste0(q_start, utils::tail(theme_colors, 1), q_end),
    "specifying the", what, "color of the tag element,",
    "defaults to `NULL`"
  )
}

#' Selected choice color
#'
#' @description
#'
#' As part of an effort to revert yonder's default bootstrap styles, the
#' `active()` utility has been deprecated. In future versions of the application
#' the function will be removed entirely.
#'
#' Previously, `active()` would change the
#' highlight color of an input's selected choices.
#'
#' @param tag A tag element.
#'
#' @eval param_color("active")
#'
#' @family design utilities
#' @export
active <- function(tag, color) {
  deprecate_soft("0.2.0", "yonder::active()")

  assert_possible(color, theme_colors)

  tag <- tag_class_add(tag, paste0("active-", color))

  tag
}

#' Float
#'
#' Use `float()` to float an element to the left or right side of its parent
#' element. A newspaper layout is a classic example where an image is floated
#' with text wrapped around.
#'
#' @param tag A tag element.
#'
#' @param side A [responsive] argument. One of `"left"` or `"right"` specifying
#'   the side to float the element.
#'
#' @family design utilities
#' @export
#' @examples
#'
#' ### Float an alert
#'
#' div(
#'   alert("This just in!") %>%
#'     margin(3) %>%
#'     background("warning") %>%
#'     float("left"),
#'   p("Fusce commodo. Nullam tempus. Nunc rutrum turpis sed pede.",
#'     "Phasellus lacus.  Cras placerat accumsan nulla.",
#'     "Fusce sagittis, libero non molestie mollis, ",
#'     "magna orci ultrices dolor, at vulputate neque nulla lacinia eros."
#'   ),
#'   p("Nulla facilisis, risus a rhoncus fermentum, tellus tellus",
#'     "lacinia purus, et dictum nunc justo sit amet elit."
#'   ),
#'   p("Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
#'     "Aliquam posuere.",
#'     "Sed id ligula quis est convallis tempor."
#'   ),
#'   p("Fusce dapibus, tellus ac cursus commodo, ",
#'     "tortor mauris condimentum nibh, ut fermentum massa justo sit",
#'     "amet risus."
#'   )
#' ) %>%
#'   padding(2)
#'
float <- function(tag, side) {
  side <- resp_construct(side, c("left", "right"))

  classes <- resp_classes(side, "float")

  tag <- tag_class_add(tag, classes)

  tag
}

#' Position
#'
#' The `affix` utility function applies Bootstrap classes to fix elements to the
#' top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
#' of a page after the element is scrolled past. *Important*, the IE11 and
#' Edge browsers do not support the sticky behavior.
#'
#' @param tag A tag element.
#'
#' @param position One of `"top"`, `"bottom"`, or `"sticky"` specifying the
#'   fixed behavior of an element.
#'
#' @family design utilities
#' @export
affix <- function(tag, position) {
  assert_possible(position, c("top", "bottom", "sticky"))

  p <- if (position == "sticky") "sticky-top" else sprintf("fixed-%s", position)

  tag_class_add(tag, p)
}

#' Display property
#'
#' Use the `display()` utility to adjust how a tag element is rendered. All
#' arguments are responsive allowing you to hide elements on small screens or
#' convert elements from inline to block on large screens.
#'
#' @param tag A tag element.
#'
#' @param type A [responsive] argument. One of `"inline"`, `"block"`,
#'   `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`.
#'
#' @family design utilities
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
display <- function(tag, type) {
  type <- resp_construct(
    type,
    c("inline", "block", "inline-block", "flex", "inline-flex", "none")
  )

  classes <- resp_classes(type, "d")

  tag_class_add(tag, classes)
}

#' Margin and padding
#'
#' Use the `margin()` and `padding()` utilities to change the margin or padding
#' of a tag element.  The margin of a tag element is the space outside and
#' around the tag element, its border, and its content.  The padding of a tag
#' element is the space between the tag element's border and its content or
#' child elements. All arguments default to `NULL`, in which case they are
#' ignored.
#'
#' @param tag A tag element.
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
#' @family design utilities
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
#'   background("info")
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
#'   id = "form1",
#'   inline = TRUE,
#'   textInput(
#'     id = "name",
#'     placeholder = "Full name"
#'   ),
#'   groupTextInput(
#'     id = "username",
#'     left = "@@",
#'     placeholder = "Username"
#'   ),
#'   checkboxInput(
#'     id = "remember",
#'     choice = "Remember me"
#'   ),
#'   formSubmit("Login", "login")
#' )
#'
#' # Without any adjustments the layout is not great. But, with some styling we
#' # can make this form sparkle. Notice we are also adjusting the default submit
#' # button added to the form input.
#'
#' formInput(
#'   id = "form2",
#'   inline = TRUE,
#'   textInput(
#'     id = "name",
#'     placeholder = "Full name"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   groupTextInput(
#'     id = "username",
#'     left = "@@",
#'     placeholder = "Username"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   checkboxInput(
#'     id = "remember",
#'     choice = "Remember me"
#'   ) %>%
#'     margin(r = c(sm = 2), b = 2),  # <-
#'   formSubmit(
#'     label = "Login",
#'     value = "login"
#'   ) %>%
#'     margin(b = 2)  # <-
#' )
#'
padding <- function(tag, all = NULL, top = NULL, right = NULL, bottom = NULL,
                    left = NULL) {
  possibles <- c(0:5, "auto")

  all <- resp_construct(all, possibles)
  top <- resp_construct(top, possibles)
  right <- resp_construct(right, possibles)
  bottom <- resp_construct(bottom, possibles)
  left <- resp_construct(left, possibles)

  classes <- c(
    resp_classes(top, "t"),
    resp_classes(right, "r"),
    resp_classes(bottom, "b"),
    resp_classes(left, "l")
  )

  if (!is.null(classes)) {
    classes <- paste0("p", classes)
  }

  classes <- c(resp_classes(all, "p"), classes)

  tag <- tag_class_add(tag, classes)

  tag
}

#' @rdname padding
#' @export
margin <- function(tag, all = NULL, top = NULL, right = NULL, bottom = NULL,
                   left = NULL) {
  possibles <- c(0:5, "auto", paste0("n", 1:5))

  format_negative <- function(x) {
    if (x < 0) paste0("n", abs(x)) else x
  }

  all <- lapply(all, format_negative)
  top <- lapply(top, format_negative)
  right <- lapply(right, format_negative)
  bottom <- lapply(bottom, format_negative)
  left <- lapply(left, format_negative)

  all <- resp_construct(all, possibles)
  top <- resp_construct(top, possibles)
  right <- resp_construct(right, possibles)
  bottom <- resp_construct(bottom, possibles)
  left <- resp_construct(left, possibles)

  classes <- c(
    resp_classes(top, "t"),
    resp_classes(right, "r"),
    resp_classes(bottom, "b"),
    resp_classes(left, "l")
  )

  if (!is.null(classes)) {
    classes <- paste0("m", classes)
  }

  classes <- c(resp_classes(all, "m"), classes)

  tag <- tag_class_add(tag, classes)

  tag
}

#' Width
#'
#' Utility function to change a tag element's width. Widths are specified
#' relative to the font size of page (browser default is 16px), relative to
#' their parent element (i.e. 1/2 the width of their parent), or relative to the
#' element's content.
#'
#' @param tag A tag element.
#'
#' @param size A character string or number specifying the width of the tag
#'   element. Possible values:
#'
#'   One of 25, 50, 75, or 100 specifying the element's width is a percentage of
#'   its parent's width. The width of the parent element must be
#'   specified. Percentages do not account for margins or padding and may cause
#'   an element to extend beyond its parent element.
#'
#'   `"auto"`, in which case the element's width is determined by the browser.
#'   The browser will take into account the width, padding, margins, and border
#'   of the tag element's parent to keep the element from extending beyond its
#'   parent.
#'
#'   `"viewport"`, in which case the element's width is determined by the size
#'   of the browser window.
#'
#' @family design utilities
#' @export
width <- function(tag, size) {
  assert_possible(size, c(25, 50, 75, 100, "auto", "viewport"))

  size <- if (size == "vieport") "vw-100" else sprintf("w-%s", size)

  tag_class_add(tag, size)
}

#' Height
#'
#' Utility function to change a tag element's height. Height is specified
#' relative to the font size of page (browser default is 16px), relative to
#' their parent element, or relative to the element's content.
#'
#' @param tag A tag element.
#'
#' @param size A character string or number specifying the height of the tag
#'   element. Possible values:
#'
#'   One of 25, 50, 75, 100 specifying the element's height as a
#'   percentage of its parent's height. The height of the parent element must
#'   also be specified. Percentages do not account for margins or padding and
#'   may cause an element to extend beyond its parent element.
#'
#'   `"auto"`, in which case the element's height is determined by the browser.
#'   The browser will take into account the height, padding, margins, and border
#'   of the tag element's parent to keep the element from extending beyond its
#'   parent.
#'
#'   `"viewport"`, in which case the element's height is determined by the size
#'   of the browser window.
#'
#' @family design utilities
#' @export
height <- function(tag, size) {
  assert_possible(size, c(25, 50, 75, 100, "auto", "viewport"))

  size <- if (size == "viewport") "vh-100" else sprintf("h-%s", size)

  tag_class_add(tag, size)
}

#' Vertical and horizontal scroll
#'
#' Many of the applications you build despite a complex layout will still fit
#' onto a single page. To help scroll long content alongside shorter content use
#' the `scroll()` utility function.
#'
#' @param tag A tag element.
#'
#' @param direction One of `"horizontal"` or `"vertical"` specifying which
#'   direction to scroll overflowing content, defaults to `"vertical"`, in which
#'   case the content may croll up and down.
#'
#' @family design utilities
#' @export
scroll <- function(tag, direction = "vertical") {
  assert_possible(direction, c("vertical", "horizontal"))

  direction <- if (direction == "vertical") "scroll-y" else "scroll-x"

  tag_class_add(tag, direction)
}
