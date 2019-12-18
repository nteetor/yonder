#' Backgrounds
#'
#' Use `background()` to modify the background color of a tag element.
#'
#' @param tag A tag element.
#'
#' @eval param_color("background")
#'
#' @family design utilities
#' @export
#' @examples
#'
#' ### Modifying input elements
#'
#' checkbarInput(
#'   id = "bar1",
#'   choices = c(
#'     "Nunc rutrum turpis sed pede.",
#'     "Etiam vel neque.",
#'     "Lorem ipsum dolor sit amet."
#'   )
#' ) %>%
#'   background("info")
#'
background <- function(tag, color, ...) {
  assert_possible(color, theme_colors)

  UseMethod("background", tag)
}

#' @export
background.yonder_style_pronoun <- function(x, color) {
  NextMethod("background", x)
}

#' @export
background.rlang_box_splice <- function(x, color) {
  NextMethod("background", unbox(x))
}

#' @export
background.default <- function(x, color) {
  tag_class_add(x, sprintf("bg-%s", color))
}

#' @export
background.yonder_badge <- function(x, color) {
  tag_class_add(x, sprintf("badge-%s", color))
}

#' @export
background.yonder_button <- function(x, color) {
  tag_class_add(x, sprintf("btn-%s", color))
}

#' @export
background.yonder_button_group <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_checkbox <- function(x, color) {
  tag_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_checkbar <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_dropdown <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_listgroup <- function(x, color) {
  tag_class_add(x, sprintf("list-group-%s", color))
}

#' @export
background.yonder_menu <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_radio <- function(tag, color) {
  tag_class_add(tag, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_radiobar <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_switch <- function(x, color) {
  tag_class_add(x, sprintf("custom-control-group-%s", color))
}
