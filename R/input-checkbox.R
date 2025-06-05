#' Checkbox and switch inputs
#'
#' Reactive checkbox and checkbar inputs. Users may select one or more choices.
#' The checkbox input appears as a standard checkbox or set of checkboxes. When
#' a checkbox input has no selected choices the reactive value is `NULL`. Switch
#' inputs differ from checkboxes only in appearance.
#'
#' @param id A character string specifying the id of the reactive input.
#'
#' @param choices A character string or vector specifying a label or labels for
#'   the checkbox or checkbar.
#'
#' @param values A character string or vector specifying values for the
#'   checkbox or checkbar input, defaults to `choice` or `values`, respectively.
#'
#' @param selected One or more of `values` specifying which choices are
#'   selected by default, defaults to `NULL`, in which case no choices are
#'   initially selected.
#'
#' @param inline One of `TRUE` or `FALSE` specifying if the checkbox input
#'   choices render inline or stacked, defaults to `FALSE`, in which case the
#'   choices are stacked.
#'
#' @param ... Additional named arguments passed as HTML attributes to the
#'   parent element or tag elements passed as child elements to the parent
#'   element.
#'
#' @param disable One of `values` specifying particular choices to disable or
#'   `TRUE` specifying the entire input is disabled, defaults to `NULL`.
#'
#' @param session A reactive context, defaults to [getDefaultReactiveDomain()].
#'
#' @family inputs
#' @export
input_checkbox <- function(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  inline = FALSE,
  ...
) {
  assert_id()
  assert_choices()

  checkboxes <-
    checkbox_build(choices, values, selected, inline)

  tag <-
    tags$div(
      class = "bsides-checkbox",
      id = id,
      checkboxes,
      ...
    )

  tag <-
    dependency_append(tag)

  tag <-
    s3_class_add(tag, c("yonder_checkbox", "yonder_input"))

  tag
}

checkbox_build <- function(
  choices,
  values,
  selected,
  inline
) {
  if (is.null(choices) && is.null(values)) {
    return(NULL)
  }

  selected <- values %in% selected

  Map(
    choice = choices,
    value = values,
    select = selected,
    function(choice, value, select) {
      id <- generate_id("checkbox")

      tags$div(
        class = "form-check",
        tags$input(
          class = "form-check-input",
          type = "checkbox",
          id = id,
          name = id,
          value = value,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "form-check-label",
          `for` = id,
          choice
        )
      )
    }
  )
}

checkbox_handler <- function(
  value,
  session,
  name
) {
  value <- unlist(value, FALSE, TRUE)

  if (length(value) < 1 || !any(value)) {
    return(NULL)
  }

  value
}

#' @rdname input_checkbox
#' @export
input_checkbox_button <- function(
  id,
  choices,
  values = choices,
  selected = NULL,
  ...
) {
  tag <-
    tags$div(
      id = id,
      class = "bsides-checkbox-button",
      ...
    )

  tag <-
    dependency_append(tag)

  tag
}

build_checkbox_buttons <- function(
  choices,
  values,
  selected
) {
  mapply(
    choices,
    values,
    selected,
    function(choice, value, select) {
      id <- generate_id("checkbox")

      list(
        tags$input(
          type = "checkbox",
          id = id,
          checked = if (select) NA,
          autocomplete = "off"
        ),
        tags$label(
          class = "btn btn-primary",
          `for` = id,
          choice
        )
      )
    }
  )
}

#' Update checkbox
#'
#' Update checkbox
#'
#' @param choices choices
#'
#' @param values values
#'
#' @param selected selected
#'
#' @param disable disable
#'
#' @param session A reactive session, [default_reactive_domain()].
#'
#' @export
update_checkbox <- function(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  disable = NULL,
  session = default_reactive_domain()
) {
  assert_id()
  assert_choices()
  assert_session()

  checkboxes <- build_checkboxes(choices, values, selected)

  content <- coerce_content(checkboxes)
  selected <- coerce_selected(selected)
  disable <- coerce_disable(disable)

  session$sendInputMessage(
    id,
    list(
      content = content,
      selected = selected,
      disable = disable
    )
  )
}
