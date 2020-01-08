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
  style_class_add(x, background_color("bg", color))
}

#' @export
background.rlang_box_splice <- function(x, color) {
  background(unbox(x), color)
}

#' @export
background.shiny.tag <- function(x, color) {
  tag_class_add(x, background_color("bg", color))
}

#' @export
background.default <- function(x, color) {
  tag_class_add(x, background_color("bg", color))
}

#' @export
background.yonder_alert <- function(x, color) {
  tag_class_add(x, background_color("alert", color))
}

#' @export
background.yonder_badge <- function(x, color) {
  tag_class_add(x, background_color("badge", color))
}

#' @export
background.yonder_button <- function(x, color) {
  tag_class_add(x, background_color("btn", color))
}

#' @export
background.yonder_button_group <- function(x, color) {
  tag_class_add(x, background_color("btn-group", color))
}

#' @export
background.yonder_checkbox <- function(x, color) {
  tag_class_add(x, background_color("custom-control-group", color))
}

#' @export
background.yonder_checkbar <- function(x, color) {
  tag_class_add(x, background_color("btn-group", color))
}

#' @export
background.yonder_dropdown <- function(x, color) {
  tag_class_add(x, background_color("btn-group", color))
}

#' @export
background.yonder_list_group <- function(x, color) {
  tag_class_add(x, background_color("list-group", color))
}

#' @export
background.yonder_menu <- function(x, color) {
  tag_class_add(x, background_color("btn-group", color))
}

#' @export
background.yonder_radio <- function(x, color) {
  tag_class_add(x, background_color("custom-control-group", color))
}

#' @export
background.yonder_radiobar <- function(x, color) {
  tag_class_add(x, background_color("btn-group", color))
}

#' @export
background.yonder_switch <- function(x, color) {
  tag_class_add(x, background_color("custom-control-group", color))
}

background_color <- function(prefix, color) {
  sprintf("%s-%s", prefix, color)
}
