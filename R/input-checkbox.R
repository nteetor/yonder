#' Checkbox input
#'
#' A reactive checkbox input. When a checkbox input has no selected choices the
#' reactive value is `NULL`.
#'
#' @param id A character string. The id of the reactive input.
#'
#' @param choice A character string. The text for the checkbox.
#'
#' @param ... Optional named arguments specifying HTML attributes for the input
#'   element.
#'
#' @param value A boolean. The default value for the checkbox.
#'
#' @param disable A boolean. The checkbox starts disabled if `TRUE`.
#'
#' @param label A character string. The label of the input, rendered ahead
#'   of the input. Floating labels are not supported.
#'
#' @param choice_placement A character string. The placement of the choice's
#'   text relative to its checkbox.
#'
#' @param session A shiny session object.
#'
#' @details
#'
#' ## Server value
#'
#' A named logical vector.
#'
#' @returns A [htmltools::tag] object.
#'
#' @family inputs
#'
#' @export
input_checkbox <-
  function(
    id,
    choice,
    ...,
    label = NULL,
    value = FALSE,
    disable = NULL,
    choice_placement = c("after", "before")
  ) {
    check_string(id, allow_empty = FALSE)

    choice_placement <- arg_match(choice_placement)

    args <- list(...)
    attrs <- keep_named(args)

    checkbox_id <- generate_id("checkbox")

    input <-
      tags$div(
        class = c(
          "bsides-input-checkbox form-check",
          if (choice_placement == "before") "form-check-reverse"
        ),
        id = id,
        !!!attrs,
        tags$input(
          class = "form-check-input",
          id = checkbox_id,
          type = "checkbox",
          checked = if (isTRUE(value)) NA,
          disabled = if (isTRUE(disable)) NA,
          `data-shiny-no-bind-input` = NA
        ),
        tags$label(
          class = "form-check-label",
          `for` = checkbox_id,
          choice
        )
      )

    input <-
      wrap_label(input, label, wrapper = "label", for_id = checkbox_id)

    input <-
      dependency_append(input)

    input <-
      s3_class_add(input, c("bsides_checkbox_input", "bsides_input"))

    input
  }

#' @rdname input_checkbox
#' @export
update_checkbox <-
  function(
    id,
    choice = NULL,
    value = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_string(id, allow_empty = FALSE)
    check_string(choice, allow_null = TRUE)
    check_bool(value, allow_null = TRUE)
    check_bool(disable, allow_null = TRUE)

    msg <-
      drop_nulls(list(
        choice = choice,
        value = value,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }
