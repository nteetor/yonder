#' Numeric input
#'
#' A numeric input.
#'
#' @inheritParams input_checkbox_group
#'
#' @param min A number. A possible minimum value for the input.
#'
#' @param max A number. A possible maximum value for the input.
#'
#' @param step A number. The interval when stepping between values.
#'
#' @param placeholder A string. The placeholder text displayed inside the input.
#'
#' @inherit input_checkbox_group return
#'
#' @family inputs
#'
#' @export
input_numeric <- function(
  id,
  ...,
  value = NULL,
  min = NULL,
  max = NULL,
  step = 1,
  placeholder = NULL
) {
  check_string(id, allow_empty = FALSE)

  input <-
    tags$input(
      id = id,
      type = "number",
      value = value,
      placeholder = placeholder,
      min = min,
      max = max,
      step = step
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_numeric_input", "bsides_input"))

  input
}
