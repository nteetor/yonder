#' Number input
#'
#' A number input. Specify a minimum or maximum allowed value with `min` or
#' `max`. Specifying `step` controls how the incremement and decrement buttons
#' modify the input value.
#'
#' @inheritParams checkboxInput
#'
#' @param value A number specifying the default value of the number input,
#'   defaults to `NULL`.
#'
#' @param placeholder A character string specifying placeholder text for the
#'   input, defaults to `NULL`, in which case there is no placeholder text.
#'
#' @param min A number specifying the minimum allowed value of the number input,
#'   defaults to `NULL`.
#'
#' @param max A number specifying the maximum allowed value of the number input,
#'   defaults to `NULL`.
#'
#' @param step A number specifying the increment step of the number input,
#'   defaults to 1.
#'
#' @export
#' @examples
#'
#' ### Default number input
#'
#' numberInput(id = "num1")
#'
#' ### Specify `min`, `max`, and `step`
#'
#' numberInput(
#'   id = "num2",
#'   min = 1,
#'   max = 10,
#'   step = 2
#' )
#'
numberInput <- function(id, value = NULL, placeholder = NULL, ..., min = NULL,
                        max = NULL, step = 1) {
  assert_id()

  dep_attach({
    tags$div(
      class = "yonder-number",
      id = id,
      tags$input(
        class = "form-control",
        type = "number",
        value = value,
        placeholder = placeholder,
        autocomplete = "off",
        min = min,
        max = max,
        step = step
      ),
      tags$div(class = "valid-feedback"),
      tags$div(class = "invalid-feedback"),
      ...
    )
  })
}
