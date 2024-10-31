#' Border colors
#'
#' Use `border()` to add or modify tag element borders.
#'
#' @inheritParams affix
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
#' @keywords internal
#'
#' @export
#'
#' @examples
#'
#' div() %>% border("primary")
#' # ->
#' div() %>% border_color("primary")
#'
border <- function(x, color = NULL, sides = "all", round = NULL) {
  lifecycle::deprecate_warn(
    "0.3.0",
    "border()",
    "cascadess::border_color()"
  )

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

#' @export
border.rlang_box_splice <- function(x, color = NULL, sides = "all",
                                    round = NULL) {
  border(unbox(x), color, sides, round)
}

#' @export
border.shiny.tag <- function(x, color = NULL, sides = "all", round = NULL) {
  tag_class_add(x, c(
    border_sides(sides),
    border_color(color),
    border_round(round)
  ))
}

#' @export
border.default <- function(x, color = NULL, sides = "all", round = NULL) {
  tag_class_add(x, c(
    border_sides(sides),
    border_color(color),
    border_round(round)
  ))
}

border_color <- function(color) {
  sprintf("border-%s", color)
}

border_sides <- function(sides) {
  if (is.null(sides)) {
    return(NULL)
  }

  if ("all" %in% sides) {
    "border"
  } else if ("none" %in% sides) {
    "border-0"
  } else {
    sprintf("border-%s", sides)
  }
}

border_round <- function(round) {
  if (is.null(round)) {
    return(NULL)
  }

  round <- sprintf("rounded-%s", round)

  round[round == "rounded-none"] <- "rounded-0"
  round[round == "rounded-all"] <- "rounded"

  round
}
