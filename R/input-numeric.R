#' Numeric input
#'
#' A numeric input.
#'
#' @inheritParams input_checkbox_group
#'
#' @param value A number. The default value of the input.
#'
#' @param min A number. A possible minimum value for the input.
#'
#' @param max A number. A possible maximum value for the input.
#'
#' @param step A number. The interval when stepping between values.
#'
#' @param placeholder A string. The placeholder text displayed inside the input.
#'
#' @param label A character string or [floating_label()]. The label of the
#'   input. A character string renders a standard label ahead of the input,
#'   a [floating_label()] renders a floating label inside the input.
#'
#' @inherit input_checkbox_group return
#'
#' @family inputs
#'
#' @export
input_numeric <-
  function(
    id,
    ...,
    label = NULL,
    value = NULL,
    min = NULL,
    max = NULL,
    step = 1,
    placeholder = NULL
  ) {
    check_string(id, allow_empty = FALSE)

    input <-
      tags$input(
        class = "form-control",
        id = id,
        type = "number",
        value = value,
        placeholder = placeholder,
        min = min,
        max = max,
        step = step
      )

    input <-
      wrap_label(
        input,
        label,
        wrapper = "label",
        for_id = id,
        floating = "supported"
      )

    input <-
      dependency_append(input)

    input <-
      s3_class_add(input, c("bsides_numeric_input", "bsides_input"))

    input
  }
