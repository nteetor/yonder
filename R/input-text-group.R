#' A text group input
#'
#' A text input with a possible static prefix or suffix.
#'
#' @inheritParams input_numeric
#'
#' @param left A character vector. One or more character strings prepended to
#'   the reactive value of the input.
#'
#' @param right A character vector. One or more character strings appended to
#'   the reactive value of the input.
#'
#' @param value A character string. The value of the input.
#'
#' @param disable A boolean. If `TRUE`, disable the input.
#'
#' @param session A shiny session object.
#'
#' @inherit input_numeric return
#'
#' @family inputs
#'
#' @export
input_text_group <-
  function(
    id,
    ...,
    label = NULL,
    left = NULL,
    right = NULL,
    value = NULL,
    placeholder = NULL
  ) {
    check_string(id, allow_empty = FALSE)

    args <- list(...)
    attrs <- keep_named(args)

    control_id <-
      if (non_null(label)) generate_id("text")

    control <-
      tags$input(
        class = "form-control",
        id = control_id,
        type = "text",
        value = value,
        placeholder = placeholder
      )

    # A floating label lives inside the group, wrapped around the control
    # itself; a standard label sits ahead of the whole group.
    if (is_floating_label(label)) {
      control <-
        wrap_label(
          control,
          label,
          wrapper = "label",
          for_id = control_id,
          floating = "supported"
        )
    }

    input <-
      tags$div(
        class = "bsides-input-text-group input-group",
        id = id,
        !!!attrs,
        !!!text_group_input_text(left),
        control,
        !!!text_group_input_text(right),
      )

    if (non_null(label) && !is_floating_label(label)) {
      input <-
        wrap_label(input, label, wrapper = "label", for_id = control_id)
    }

    input <-
      dependency_append(input)

    input <-
      s3_class_add(input, c("bsides_text_group_input", "bsides_input"))

    input
  }

#' @rdname input_text_group
#' @export
update_text_group <-
  function(
    id,
    value = NULL,
    disable = NULL,
    session = get_current_session()
  ) {
    check_string(id, allow_empty = FALSE)

    msg <-
      drop_nulls(list(
        value = value,
        disable = disable
      ))

    session$sendInputMessage(id, msg)
  }

text_group_input_text <-
  function(values) {
    lapply(values, \(v) tags$span(class = "input-group-text", v))
  }
