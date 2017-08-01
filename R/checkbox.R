#' Checkbox inputs
#'
#' A reactive checkbox input. When a checkbox input is unchecked the reactive
#' value is `NULL`. When checked the checkbox input reactive value is `value`.
#'
#' @param id A character string specifying the id of the checkbox input, the
#'   reactive value of the checkbox input is available to the shiny server
#'   function as part of the `input` object.
#'
#' @param label A character string specifying a label for the checkbox.
#'
#' @param value A character string, object to coerce to a character string, or
#'   `NULL` specifying the value of the checkbox or a new value for the
#'   checkbox.
#'
#' @param header A character string specifying a header for the checkbox input,
#'   defaults to `NULL`, in which case a header is not added.
#'
#' @param checked If `TRUE` the checkbox renders in a checked state, defaults
#'   to `FALSE`.
#'
#' @param inline If `TRUE`, the padding and margins of the checkbox input are
#'   adjusted to better suit an inline form, defaults to `FALSE`.
#'
#' @param state An expression whose return value is used to update the visual
#'   context of the checkbox input. If the expression returns one of
#'   `"success"`, `"warning"`, `"danger"` the visual context is updated
#'   accordingly. If the return value is `NULL` any visual context is removed.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkboxInput(
#'             id = "checkbox",
#'             label = "Are you there?",
#'             value = "yes"
#'           )
#'         ),
#'         col(
#'
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$checkbox, {
#'         print(input$checkbox)
#'       })
#'     }
#'   )
#' }
#'
checkboxInput <- function(id, label, value, title = NULL, checked = FALSE,
                          inline = FALSE, ...) {
  value <- as.character(value)

  tags$div(
    class = collate(
      "dull-checkbox-input",
      "dull-input",
      "form-group",
      if (inline) "mb-2 mr-sm-2 mb-sm-0"
    ),
    tags$label(
      class = collate(
        "custom-control",
        "custom-checkbox"
      ),
      tags$input(
        class = "custom-control-input",
        type = "checkbox",
        `data-value` = value,
        checked = if (checked) NA
      ),
      tags$span(
        class = "custom-control-indicator"
      ),
      tags$span(
        class = "custom-control-description",
        label
      )
    ),
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname checkboxInput
#' @export
updateCheckboxInput <- function(id, value,
                                session = getDefaultReactiveDomain()) {
  value <- as.character(value)

  session$sendInputMessage(
    id,
    list(
      value = value
    )
  )
}

#' @rdname checkboxInput
#' @export
validateCheckboxInput <- function(id, state,
                                  session = getDefaultReactiveDomain()) {
  if (!re(state, "success|warning|danger")) {
    stop(
      "invalid `validateCheckboxInput` argument, `state` must be one ",
      '"success", "warning", "danger", or NULL',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      state = state
    )
  )
}

#' @rdname checkboxInput
#' @export
disableCheckboxInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      disable = TRUE
    )
  )
}

#' @rdname checkboxInput
#' @export
enableCheckboxInput <- function(id, session = getDefaultReactiveDomain()) {
  session$sendInputMessage(
    id,
    list(
      enable = TRUE
    )
  )
}
