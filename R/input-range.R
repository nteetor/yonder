#' Range input
#'
#' A simple numeric range input.
#'
#' @inheritParams input_checkbox
#'
#' @param min A number. The input's minimum value, defaults to `0`.
#'
#' @param max A number. The input's maximum value, defaults to `100`.
#'
#' @param value A number. The value of the input, between `min` and
#'   `max`.
#'
#' @param step A number. The input's step interval.
#'
#' @details
#'
#' The sophistication of this input will improve as browsers adopt the latest
#' HTML standards.
#'
#' @inherit input_checkbox return
#'
#' @family inputs
#'
#' @export
input_range <- function(
  id,
  ...,
  min = 0,
  max = 100,
  value = min,
  step = 1
) {
  check_string(id, allow_empty = FALSE)
  check_number_decimal(min)
  check_number_decimal(max)
  check_number_decimal(value, min = min, max = max)
  check_number_decimal(step)

  input <-
    tags$div(
      class = "bsides-range",
      id = id,
      tags$input(
        class = "form-range",
        type = "range",
        step = step,
        min = min,
        max = max,
        value = value
      ),
      ...
    )

  input <-
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_range_input", "bsides_input"))

  input
}

#' @rdname input_range
#' @export
update_range <- function(
  id,
  value = NULL,
  disable = NULL,
  session = get_current_session()
) {
  check_string(id, allow_empty = FALSE)
  check_number_decimal(value, allow_null = TRUE)
  check_number_decimal(disable, allow_null = TRUE)

  msg <-
    drop_nulls(list(
      value = value,
      disable = disable
    ))

  session$sendInputMessage(id, msg)
}
