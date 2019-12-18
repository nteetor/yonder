#' Tag element padding
#'
#' Use the `padding()` function to change the inner spacing of a tag element.
#' The padding of a tag element is the space between the tag element's border
#' and its content or child elements. All arguments default to `NULL`, in which
#' case they are ignored.
#'
#' @inheritParams affix
#'
#' @param all,top,right,bottom,left A [responsive] argument. One of `0:5` or
#'   `"auto"` specifying padding for one or more sides of the tag element. 0
#'   removes all inner space and 5 adds the most space.
#'
#' @family design utilities
#' @export
padding <- function(x, all = NULL, top = NULL, right = NULL, bottom = NULL,
                    left = NULL) {
  UseMethod("padding", x)
}

#' @export
padding.yonder_style_pronoun <- function(x, all = NULL, top = NULL,
                                         right = NULL, bottom = NULL,
                                         left = NULL) {
  UseMethod("padding.yonder_style_pronoun", x)
}

#' @export
padding.rlang_box_splice <- function(x, all = NULL, top = NULL, right = NULL,
                                     bottom = NULL, left = NULL) {
  UseMethod("padding.yonder_style_pronoun", unbox(x))
}

#' @export
padding.shiny.tag <- function(x, all = NULL, top = NULL, right = NULL,
                              bottom = NULL, left = NULL) {
  tag_class_add(x, c(
    padding_all(all),
    padding_top(top),
    padding_right(right),
    padding_bottom(bottom),
    padding_left(left)
  ))
}

#' @export
padding.yonder_style_pronoun.default <- function(x, all = NULL, top = NULL,
                                                 right = NULL, bottom = NULL,
                                                 left = NULL) {
  style_class_add(x, c(
    padding_all(all),
    padding_top(top),
    padding_right(right),
    padding_bottom(bottom),
    padding_left(left)
  ))
}

padding_top <- function(top) {
  if (is.null(top)) {
    return(NULL)
  }

  top <- resp_construct(top, c(0:5, "auto"))

  sprintf("p%s", resp_classes(top, "t"))
}

padding_right <- function(right) {
  if (is.null(right)) {
    return(NULL)
  }

  right <- resp_construct(right, c(0:5, "auto"))

  sprintf("p%s", resp_classes(right, "r"))
}

padding_bottom <- function(bottom) {
  if (is.null(bottom)) {
    return(NULL)
  }

  bottom <- resp_construct(bottom, c(0:5, "auto"))

  sprintf("p%s", resp_classes(bottom, "b"))
}

padding_left <- function(left) {
  if (is.null(left)) {
    return(NULL)
  }

  left <- resp_construct(left, c(0:5, "auto"))

  sprintf("p%s", resp_classes(left, "l"))
}

padding_all <- function(all) {
  if (is.null(all)) {
    return(NULL)
  }

  all <- resp_construct(all, c(0:5, "auto"))

  resp_classes(all, "p")
}

#' Tag element margins
#'
#' Use the `margin()` function to change the outer spacing of a tag element.
#' The margin of a tag element is the space outside and around the tag element,
#' its border, and its content.  All arguments default to `NULL`, in which case
#' they are ignored.
#'
#' @inheritParams affix
#'
#' @param all,top,right,bottom,left A [responsive] argument. One of `-5:5` or
#'   `"auto"` specifying a margin for one or more sides of the tag element. 0
#'   removes all outer space, 5 adds the most space, and negative values will
#'   consume space pulling the element in that direction.
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
margin <- function(x, all = NULL, top = NULL, right = NULL, bottom = NULL,
                   left = NULL) {
  UseMethod("margin", x)
}

#' @export
margin.yonder_style_pronoun <- function(x, all = NULL, top = NULL,
                                        right = NULL, bottom = NULL,
                                        left = NULL) {
  UseMethod("margin.yonder_style_pronoun", x)
}

#' @export
margin.rlang_box_splice <- function(x, all = NULL, top = NULL, right = NULL,
                                    bottom = NULL, left = NULL) {
  UseMethod("margin.yonder_style_pronoun", unbox(x))
}

#' @export
margin.shiny.tag <- function(x, all = NULL, top = NULL, right = NULL,
                             bottom = NULL, left = NULL) {
  tag_class_add(x, c(
    margin_all(all),
    margin_top(top),
    margin_right(right),
    margin_bottom(bottom),
    margin_left(left)
  ))
}

#' @export
margin.yonder_style_pronoun.default <- function(x, all = NULL, top = NULL,
                                                right = NULL, bottom = NULL,
                                                left = NULL) {
  style_class_add(x, c(
    margin_all(all),
    margin_top(top),
    margin_right(right),
    margin_bottom(bottom),
    margin_left(left)
  ))
}

margin_top <- function(top) {
  if (is.null(top)) {
    return(NULL)
  }

  top <- lapply(top, margin_negative)
  top <- resp_construct(top, c(0:5, "auto", "n1", "n2", "n3", "n4", "n5"))

  sprintf("p%s", resp_classes(top, "t"))
}

margin_right <- function(right) {
  if (is.null(right)) {
    return(NULL)
  }

  right <- lapply(right, margin_negative)
  right <- resp_construct(right, c(0:5, "auto", "n1", "n2", "n3", "n4", "n5"))

  sprintf("p%s", resp_classes(right, "r"))
}

margin_bottom <- function(bottom) {
  if (is.null(bottom)) {
    return(NULL)
  }

  bottom <- lapply(bottom, margin_negative)
  bottom <- resp_construct(bottom, c(0:5, "auto", "n1", "n2", "n3", "n4", "n5"))

  sprintf("p%s", resp_classes(bottom, "b"))
}

margin_left <- function(left) {
  if (is.null(left)) {
    return(NULL)
  }

  left <- lapply(left, margin_negative)
  left <- resp_construct(left, c(0:5, "auto", "n1", "n2", "n3", "n4", "n5"))

  sprintf("m%s", resp_classes(left, "l"))
}

margin_all <- function(all) {
  if (is.null(all)) {
    return(NULL)
  }

  all <- lapply(all, margin_negative)
  all <- resp_construct(all, c(0:5, "auto", "n1", "n2", "n3", "n4", "n5"))

  resp_classes(all, "m")
}

margin_negative <- function(x) {
  if (x < 0) {
    paste0("n", abs(x))
  } else {
    x
  }
}
