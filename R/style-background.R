#' Background color
#'
#' Use `background()` to modify the background color of a tag element.
#'
#' @inheritParams affix
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
#'   .style %>% background("info"),
#'   id = "bar1",
#'   choices = c(
#'     "Nunc rutrum turpis sed pede.",
#'     "Etiam vel neque.",
#'     "Lorem ipsum dolor sit amet."
#'   )
#' )
#'
background <- function(x, color) {
  assert_possible(color, theme_colors)

  UseMethod("background", x)
}

#' @export
background.yonder_style_pronoun <- function(x, color) {
  assert_possible(color, theme_colors)

  UseMethod("background.yonder_style_pronoun", x)
}

#' @export
background.rlang_box_splice <- function(x, color) {
  UseMethod("background.yonder_style_pronoun", unbox(x))
}

#' @export
background.shiny.tag <- function(x, color) {
  tag_class_add(x, sprintf("bg-%s", color))
}

#' @export
background.yonder_style_pronoun.default <- function(x, color) {
  style_class_add(x, sprintf("bg-%s", color))
}

#' @export
background.yonder_alert <- function(x, color) {
  tag_class_add(x, sprintf("alert-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_alert <- function(x, color) {
  style_class_add(x, sprintf("alert-%s", color))
}

#' @export
background.yonder_badge <- function(x, color) {
  tag_class_add(x, sprintf("badge-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_badge <- function(x, color) {
  style_class_add(x, sprintf("badge-%s", color))
}

#' @export
background.yonder_button <- function(x, color) {
  tag_class_add(x, sprintf("btn-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_button <- function(x, color) {
  style_class_add(x, sprintf("btn-%s", color))
}

#' @export
background.yonder_button_group <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_button_group <- function(x, color) {
  style_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_checkbox <- function(x, color) {
  tag_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_checkbox <- function(x, color) {
  style_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_checkbar <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_checkbar <- function(x, color) {
  style_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_dropdown <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_dropdown <- function(x, color) {
  style_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_listgroup <- function(x, color) {
  tag_class_add(x, sprintf("list-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_listgroup <- function(x, color) {
  style_class_add(x, sprintf("list-group-%s", color))
}

#' @export
background.yonder_radio <- function(x, color) {
  tag_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_radio <- function(x, color) {
  style_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_switch <- function(x, color) {
  tag_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_switch <- function(x, color) {
  style_class_add(x, sprintf("custom-control-group-%s", color))
}

#' @export
background.yonder_radiobar <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_radiobar <- function(x, color) {
  style_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_menu <- function(x, color) {
  tag_class_add(x, sprintf("btn-group-%s", color))
}

#' @export
background.yonder_style_pronoun.yonder_menu <- function(x, color) {
  style_class_add(x, sprintf("btn-group-%s", color))
}
