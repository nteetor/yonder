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
