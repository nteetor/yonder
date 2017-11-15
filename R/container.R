#' Grid system and responsive layout
#'
#' Flexbox, grid layout, containers, rows, and columns (oh my). Arguments `width` and
#' `order` can be applied depending on the width of the page, see the details
#' section for more information.
#'
#' @param ... Any number of child elements or named arguments passed as HTML
#'   attributes to the parent element. `row`s need to be placed inside a
#'   `container`. A `row` typically contains only `col`s. A `col` may contain
#'   other `col`s or any number of other elements.
#'
#' @export
#' @examples
#'
#' stub
#'
col <- function(..., default = NULL, small = NULL, medium = NULL,
                large = NULL, extralarge = NULL) {

  tags$div(
    class = collate(
      default %||% "col",
      small,
      medium,
      large,
      extralarge
    ),
    ...,
    bootstrap()
  )
}

#' @rdname col
#' @export
row <- function(...) {
  tags$div(
    class = "row",
    ...,
    bootstrap()
  )
}

#' @rdname col
#' @export
container <- function(..., fluid = TRUE) {
  tags$div(
    class = if (fluid) "container-fluid" else "container",
    ...,
    bootstrap()
  )
}
