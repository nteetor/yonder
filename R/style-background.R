#' Background color
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

background.yonder_style_accumulator <- function(tag, color, ...) {
  UseMethod("background.yonder_style_accumulator", tag)
}

background.shiny.tag <- function(tag, color) {
  tag_class_add(tag, sprintf("bg-%s", color))
}

background.yonder_style_accumulator.default <- function(tag, color) {
  style_class_add(tag, sprintf("bg-%s", color))
}

background.yonder_alert <- function(tag, color) {
  tag_class_add(tag, sprintf("alert-%s", color))
}

background.yonder_style_accumulator.yonder_alert <- function(tag, color) {
  style_class_add(tag, sprintf("alert-%s", color))
}

background.yonder_badge <- function(tag, color) {
  tag_class_add(tag, sprintf("badge-%s", color))
}

background.yonder_style_accumulator.yonder_badge <- function(tag, color) {
  style_class_add(tag, sprintf("badge-%s", color))
}

background.yonder_button <- function(tag, color) {
  tag_class_add(tag, sprintf("btn-%s", color))
}

background.yonder_style_accumulator.yonder_button <- function(tag, color) {
  style_class_add(tag, sprintf("btn-%s", color))
}

background.yonder_button_group <- function(tag, color) {
  tag_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_style_accumulator.yonder_button_group <- function(tag, color) {
  style_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_checkbox <- function(tag, color) {
  tag_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_style_accumulator.yonder_checkbox <- function(tag, color) {
  style_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_checkbar <- function(tag, color) {
  tag_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_style_accumulator.yonder_checkbar <- function(tag, color) {
  style_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_dropdown <- function(tag, color) {
  toggle <- tag$children[[1]]

  tag$children[[1]] <- tag_class_add(toggle, sprintf("btn-%s", color))

  tag
}

background.yonder_style_accumulator.yonder_dropdown <- function(tag, color) {
  style_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_listgroup <- function(tag, color) {
  tag_class_add(tag, sprintf("list-group-%s", color))
}

background.yonder_style_accumulator.yonder_listgroup <- function(tag, color) {
  style_class_(tag, sprintf("list-group-%s", color))
}

background.yonder_radio <- function(tag, color) {
  tag_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_style_accumulator.yonder_radio <- function(tag, color) {
  style_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_switch <- function(tag, color) {
  tag_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_style_accumulator.yonder_switch <- function(tag, color) {
  style_class_add(tag, sprintf("custom-control-group-%s", color))
}

background.yonder_radiobar <- function(tag, color) {
  tag_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_style_accumulator.yonder_radiobar <- function(tag, color) {
  style_class_add(tag, sprintf("btn-group-%s", color))
}

background.yonder_menu <- function(tag, color) {
  toggle <- tag$children[[1]]

  tag$children[[1]] <- tag_class_add(toggle, sprintf("btn-%s", color))

  tag
}

background.yonder_style_accumulator.yonder_menu <- function(tag, color) {
  style_class_add(tag, sprintf("btn-group-%s", color))
}
