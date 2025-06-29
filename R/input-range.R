#' Range input
#'
#' `rangeInput()` creates a simple numeric range input.
#'
#' @inheritParams input_checkbox
#'
#' @param min A number specifying the minimum value of the input, defaults to
#'   `0`.
#'
#' @param max A number specifying the maximum value of the input, defaults to
#'   `100`.
#'
#' @param default A number between `min` and `max` specifying the default value
#'   of the input, defaults to `min`.
#'
#' @param step A number specifying the interval step of the input, defaults to
#'   `1`.
#'
#' @param value A number specifying a new value for the input, defaults to
#'   `NULL`.
#'
#' @details
#'
#' The sophistication of this input will improve as browsers adopt the latest
#' HTML standards.
#'
#' @family inputs
#' @export
rangeInput <- function(id, min = 0, max = 100, default = min, step = 1, ...) {
  assert_id()

  if (!is.numeric(min)) {
    stop(
      "invalid argument in `rangeInput()`, `min` must be a number",
      call. = FALSE
    )
  }

  if (!is.numeric(max)) {
    stop(
      "invalid argument in `rangeInput()`, `max` must be a number",
      call. = FALSE
    )
  }

  if (!is.numeric(default)) {
    stop(
      "invalid argument in `rangeInput()`, `default` must be a number",
      call. = FALSE
    )
  }

  if (default < min || default > max) {
    stop(
      "invalid argument in `rangeInput()`, `default` must be between `min` ",
      "and `max`",
      call. = FALSE
    )
  }

  if (!is.numeric(step)) {
    stop(
      "invalid argument in `rangeInput()`, `step` must be a number",
      call. = FALSE
    )
  }

  dep_attach({
    tags$div(
      class = "yonder-range",
      id = id,
      tags$input(
        class = "custom-range",
        type = "range",
        step = step,
        min = min,
        max = max,
        value = default,
        autocomplete = "off"
      ),
      ...
    )
  })
}

#' @rdname rangeInput
#' @export
updateRangeInput <- function(id, value = NULL, enable = NULL, disable = NULL,
                             session = getDefaultReactiveDomain()) {
  assert_id()
  assert_session()

  if (!is.null(value)) {
    value <- as.numeric(value)
  }

  enable <- coerce_enable(enable)
  disable <- coerce_disable(disable)

  session$sendInputMessage(id, list(
    value = value,
    enable = enable,
    disable = disable
  ))
}
