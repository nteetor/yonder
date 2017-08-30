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

default <- function(width = NULL, margins = NULL, padding = NULL) {
  c(
    if (is.null(width)) "col" else paste0("col-", width),
    margins %!!% sprintf(margins, "-"),
    padding %!!% sprintf(padding, "-")
  )
}

small <- function(width = NULL, margins = NULL, padding = NULL) {
  c(
    width %!!% sprintf(width, "-sm-"),
    margins %!!% sprintf(margins, "-sm-"),
    padding %!!% sprintf(padding, "-sm-")
  )
}

medium <- function(width = NULL, margins = NULL, padding = NULL) {
  c(
    width %!!% paste0("col-md-", width),
    margins %!!% sprintf(margins, "-md-"),
    padding %!!% sprintf(padding, "-md-")
  )
}

large <- function(width = NULL, margins = NULL, padding = NULL) {
  c(
    width %!!% paste0("col-lg-", width),
    margins %!!% sprintf(margins, "-lg-"),
    padding %!!% sprintf(padding, "-lg-")
  )
}

extralarge <- function(width = NULL, margins = NULL, padding = NULL) {
  c(
    width %!!% paste0("col-xl-", width),
    margins %!!% sprintf(margins, "-xl-"),
    padding %!!% sprintf(padding, "-xl-")
  )
}

margins <- function(sizes, sides = c("top", "right", "bottom", "left")) {
  sides <- unique(sides)

  if (length(sizes) > 1 && length(sizes) != length(sides)) {
    stop(
      "invalid `margins` argument, if multiples sizes specified `sides` and ",
      "`sizes` must be the same length",
      call. = FALSE
    )
  }

  if (!all(sizes %in% 1:5)) {
    stop(
      "invalid `margins` argument, `sizes` values must be one of 1, 2, 3, 4, ",
      "or, 5",
      call. = FALSE
    )
  }

  if (!all(re(sides, "top|right|bottom|left", FALSE))) {
    stop(
      "invalid `margins` argument, `sides` must be one or more of ",
      '"top", "right", "bottom", or "left',
      call. = FALSE
    )
  }

  if (length(sides) == 4) {
    sides <- NULL
  } else {
    sides <- substr(sides, 1, 1)
  }

  paste0("m", sides, "%s", sizes)
}

padding <- function(sizes, sides = c("top", "right", "bottom", "left")) {
  sides <- unique(sides)

  if (length(sizes) > 1 && length(sizes) != length(sides)) {
    stop(
      "invalid `padding` argument, if multiples sizes specified `sides` and ",
      "`sizes` must be the same length",
      call. = FALSE
    )
  }

  if (!all(sizes %in% 1:5)) {
    stop(
      "invalid `padding` argument, `sizes` values must be one of 1, 2, 3, 4, ",
      "or, 5",
      call. = FALSE
    )
  }

  if (!all(re(sides, "top|right|bottom|left", FALSE))) {
    stop(
      "invalid `padding` argument, `sides` must be one or more of ",
      '"top", "right", "bottom", or "left',
      call. = FALSE
    )
  }

  if (length(sides) == 4) {
    sides <- NULL
  } else {
    sides <- substr(sides, 1, 1)
  }

  paste0("p", sides, "%s", sizes)
}
