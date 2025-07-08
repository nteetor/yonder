#' Checkbox input
#'
#' A reactive checkbox input. Users may select one or more choices. When a
#' checkbox input has no selected choices the reactive value is `NULL`.
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
#' @param label A character string. The placement of a label relative to its
#'   checkbox.
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
#' @export
input_checkbox <- function(
  id,
  choice,
  ...,
  value = FALSE,
  disable = NULL,
  label = c("after", "before")
) {
  check_string(id, allow_empty = FALSE)

  label <- arg_match(label)

  args <- list(...)
  attrs <- keep_named(args)

  checkbox_id <- generate_id("checkbox")

  input <-
    tags$div(
      class = "bsides-checkbox form-check",
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
    dependency_append(input)

  input <-
    s3_class_add(input, c("bsides_checkbox_input", "bsides_input"))

  input
}

#' @rdname input_checkbox
#' @export
update_checkbox <- function(
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
