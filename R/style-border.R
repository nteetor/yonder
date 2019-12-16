#' Border color
#'
#' Use `border()` to add or modify tag element borders.
#'
#' @param tag A tag element.
#'
#' @eval param_color("border")
#'
#' @param sides One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
#'   `"all"` or `"none"` specifying which sides to add a border to, defaults to
#'   `"all"`.
#'
#' @param round One or more of `"top"`, `"right"`, `"bottom"`, `"left"`,
#'   `"circle"`, `"all"`, or `"none"` specifying how to round the border(s) of a
#'   tag element, defaults to `NULL`, in which case the argument is ignored.
#'
#' @family design utilities
#' @export
border <- function(tag, color = NULL, sides = "all", round = NULL) {
  assert_possible(color, theme_colors)
  assert_possible(
    sides,
    c("top", "right", "bottom", "left", "all", "none", "circle")
  )
  assert_possible(
    round,
    c("top", "right", "bottom", "left", "all", "none")
  )

  UseMethod("border")
}

border.yonder_style_accumulator <- function(tag, color = NULL, sides = "all",
                                            round = NULL) {
  UseMethod("border.yonder_style_accumulator", tag)
}

border.shiny.tag <- function(tag, color = NULL, sides = "all", round = NULL) {
  if ("all" %in% sides) {
    tag <- tag_class_add(tag, "border")
  } else if ("none" %in% sides) {
    tag <- tag_class_add(tag, "border-0")
  } else {
    tag <- tag_class_add(tag, sprintf("border-%s", sides))
  }

  if (!is.null(color)) {
    tag <- tag_class_add(tag, sprintf("border-%s", color))
  }

  if (!is.null(round)) {
    round <- sprintf("rounded-%s", round)

    round[round == "rounded-none"] <- "rounded-0"
    round[round == "rounded-all"] <- "rounded"

    tag <- tag_class_add(tag, round)
  }

  tag
}
