#' Group button inputs
#'
#' A set of buttons with custom values.
#'
#' @param ... Button inputs to group.
#'
#' @param vertical A boolean. If `TRUE`, vertically stack the buttons.
#'
#' @export
button_group <- function(
  ...
) {
  tag <-
    div(
      class = "btn-group",
      ...
    )

  tag <-
    s3_class_add(tag, "yonder_button_group")

  tag
}

#' @rdname button_group
#' @export
button_toolbar <- function(
  ...
) {
  tag <-
    div(
      class = "btn-toolbar",
      role = "toolbar",
      ...
    )

  tag <-
    s3_class_add(tag, "yonder_button_toolbar")

  tag
}
