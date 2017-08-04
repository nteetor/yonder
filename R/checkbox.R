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
#'   checkbox, defaults to `label`.
#'
#' @param header A character string specifying a header for the checkbox input,
#'   defaults to `NULL`, in which case a header is not added.
#'
#' @param checked If `TRUE` the checkbox renders in a checked state, defaults
#'   to `FALSE`.
#'
#' @param state One of `"valid"`, `"warning"`, or `"danger"` indicating the
#'   state of the checkbox input. If the return value is `"valid"` any visual
#'   context is removed.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
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
#'           display1(
#'             textOutput("value")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       output$value <- renderText({
#'         input$checkbox
#'       })
#'     }
#'   )
#' }
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkboxInput(
#'             id = "caps",
#'             label = "Capslock?",
#'             value = "capslock"
#'           )
#'         ),
#'         col(
#'           checkboxInput(
#'             id = "question",
#'             label = "Please check this box",
#'             value = "checked"
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         if (isTruthy(input$caps)) {
#'           updateCheckboxInput(
#'             id = "question",
#'             label = "PLEASE CHECK THIS BOX",
#'             value = "checked"
#'           )
#'         } else {
#'           updateCheckboxInput(
#'             id = "question",
#'             label = "Please check this box",
#'             value = "checked"
#'           )
#'         }
#'       })
#'     }
#'   )
#' }
#'
checkboxInput <- function(id, label, value = label, title = NULL,
                          checked = FALSE, ...) {
  value <- as.character(value)

  tags$div(
    class = collate(
      "dull-checkbox-input",
      "dull-input",
      "form-group"
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
updateCheckboxInput <- function(id, label, value = label, checked = FALSE,
                                session = getDefaultReactiveDomain()) {
  this <- tags$label(
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
  )

  session$sendInputMessage(
    id,
    list(
      content = as.character(this)
    )
  )
}

#' @rdname checkboxInput
#' @export
validateCheckboxInput <- function(id, state,
                                  session = getDefaultReactiveDomain()) {
  if (!re(state, "valid|success|warning|danger", len0 = FALSE)) {
    stop(
      "invalid `validateCheckboxInput` argument, `state` must be one ",
      '"valid", "warning", or "danger"',
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
