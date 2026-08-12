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
#' @seealso [update_numeric()]
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
    check_number_decimal(value, allow_null = TRUE)
    check_number_decimal(min, allow_null = TRUE)
    check_number_decimal(max, allow_null = TRUE)
    check_number_decimal(step, allow_null = TRUE)

    args <- list(...)
    attrs <- keep_named(args)

    input <-
      tags$input(
        class = "bsides-input-numeric form-control",
        id = id,
        type = "number",
        value = format_no_sci(value),
        placeholder = placeholder,
        min = format_no_sci(min),
        max = format_no_sci(max),
        step = format_no_sci(step),
        !!!attrs
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

#' Update a numeric input
#'
#' Update the value, bounds, or state of an [input_numeric()].
#'
#' @inheritParams input_numeric
#'
#' @param ... These dots are for future extensions and must be empty.
#'
#' @param value A number. The new value of the input.
#'
#' @param min A number. The new minimum value of the input.
#'
#' @param max A number. The new maximum value of the input.
#'
#' @param step A number. The new interval when stepping between values.
#'
#' @param disable A boolean. If `TRUE`, disable the input.
#'
#' @param session A shiny session object.
#'
#' @returns No return value, called for side effects.
#'
#' @seealso [input_numeric()]
#'
#' @export
update_numeric <-
  function(
    id,
    ...,
    value = NULL,
    min = NULL,
    max = NULL,
    step = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_dots_empty()
    check_string(id, allow_empty = FALSE)
    check_number_decimal(value, allow_null = TRUE)
    check_number_decimal(min, allow_null = TRUE)
    check_number_decimal(max, allow_null = TRUE)
    check_number_decimal(step, allow_null = TRUE)
    check_bool(disable, allow_null = TRUE)

    msg <-
      drop_nulls(list(
        value = format_no_sci(value),
        min = format_no_sci(min),
        max = format_no_sci(max),
        step = format_no_sci(step),
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }
