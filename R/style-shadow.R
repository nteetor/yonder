#' Shadows
#'
#' The `shadow` utility applies a shadow to a tag element. Elements with a
#' shadow may appear to pop off the page. The material design set of components,
#' used on Android and for Google applications, commonly uses shadowing.
#' Although `"none"` is an allowed `size`, most elements do not have a shadow by
#' default.
#'
#' @param tag A tag element.
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
#'     background("cyan") %>%
#'     shadow("small") %>%
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
shadow <- function(tag, size = "medium") {
  assert_possible(size, c("none", "small", "medium", "large"))

  UseMethod("shadow", tag)
}

shadow.yonder_style_pronoun <- function(tag, ...) {
  UseMethod("shadow.yonder_style_pronoun", tag)
}

shadow.shiny.tag <- function(tag, size) {
  if (size == "regular") {
    deprecate_soft(
      "0.2.0", 'yonder::shadow(size = )', 'yonder::shadow(size = )',
      "Value 'medium' has been replaced by the value 'regular'"
    )

    size <- "medium"
  }

  tag_class_add(tag, c(
    shadow_size(size)
  ))
}

shadow.yonder_style_pronoun.default <- function(tag, size) {
  if (size == "regular") {
    deprecate_soft(
      "0.2.0", 'yonder::shadow(size = )', 'yonder::shadow(size = )',
      "Value 'medium' has been replaced by the value 'regular'"
    )

    size <- "medium"
  }

  style_class_add(tag, c(
    shadow_size(size)
  ))
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
