#' Group button inputs
#'
#' A set of buttons with custom values.
#'
#' @param ... Button inputs to group.
#'
#' @export
button_group <- function(
  ...
) {
  component <-
    tags$div(
      class = "btn-group",
      ...
    )

  component <-
    dependency_append(component)

  component <-
    s3_class_add(component, "bsides_button_group")

  component
}

#' @rdname button_group
#' @export
button_toolbar <- function(
  ...
) {
  component <-
    tag$div(
      class = "btn-toolbar",
      role = "toolbar",
      ...
    )

  component <-
    dependency_append(component)

  compnent <-
    s3_class_add(component, "bsides_button_toolbar")

  component
}
