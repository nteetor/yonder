#' Shadows
#'
#' The `shadow` utility applies a shadow to a tag element. By default many
#' elements include a shadow to help distinguish them. Use `"none"` to remove an
#' element's shadow.
#'
#' @inheritParams affix
#'
#' @param size One of `"none"`, `"small"`, `"medium"`, or `"large"` specifying
#'   the amount of shadow added, defaults to `"medium"`.
#'
#' @family design utilities
#' @export
#' @examples
#'
#' ### Styling a navbar
#'
#' div(
#'   navbar(brand = "Navbar") %>%
#'     background("dark") %>%
#'     font("light") %>%
#'     margin(bottom = 3),
#'   p(
#'     "Cras mattis consectetur purus sit amet fermentum. Donec sed ",
#'     "odio dui. Lorem ipsum dolor sit amet, consectetur adipiscing ",
#'     "elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
#'     "venenatis vestibulum."
#'   )
#' )
#'
#' ### Different shadows
#'
#' div(
#'   buttonInput(id = "b1", label = "Small") %>%
#'     margin(2) %>%
#'     shadow("small"),
#'   buttonInput(id = "b2", label = "Medium") %>%
#'     margin(2) %>%
#'     shadow("medium"),
#'   buttonInput(id = "b3", label = "Large") %>%
#'     margin(2) %>%
#'     shadow("large")
#' )
#'
shadow <- function(x, size = "medium") {
  assert_possible(size, c("none", "small", "medium", "large"))

  UseMethod("shadow", x)
}

#' @export
shadow.yonder_style_pronoun <- function(x, size = "medium") {
  NextMethod("shadow", x)
}

#' @export
shadow.rlang_box_splice <- function(x, size = "medium") {
  NextMethod("shadow", unbox(x))
}

#' @export
shadow.shiny.tag <- function(x, size = "medium") {
  if (size == "regular") {
    deprecate_soft(
      "0.2.0", 'yonder::shadow(size = )', 'yonder::shadow(size = )',
      "Value 'regular' has been replaced by the value 'medium'"
    )

    size <- "medium"
  }

  tag_class_add(x, shadow_size(size))
}

#' @export
shadow.default <- function(x, size = "medium") {
  if (size == "regular") {
    deprecate_soft(
      "0.2.0", 'yonder::shadow(size = )', 'yonder::shadow(size = )',
      "Value 'regular' has been replaced by the value 'medium'"
    )

    size <- "medium"
  }

  tag_class_add(x, shadow_size(size))
}

shadow_size <- function(size) {
  switch(
    size,
    none = "shadow-none",
    small = "shadow-sm",
    medium = "shadow",
    large = "shadow-lg"
  )
}
