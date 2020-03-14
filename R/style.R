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
    "defaults to `NULL`."
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
