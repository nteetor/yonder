#' Checkbox inputs and checkbox bars
#'
#' A reactive input for selecting one or more values. A checkbox bar is a
#' visually re-styling of a group of checkboxes. A checkbox bar appears as a set
#' of buttons, but still acts as a checkbox group. Because checkbox bars are
#' pseudo-buttons a visual context may be specified.
#'
#' @param id A character string specifying the id of the checkbox input,
#'   defaults to `NULL`, in which case the checkbox element is rendered, but a
#'   reactive value is not passed to the shiny server function.
#'
#' @param label A character string specifying a label for the checkbox, defaults
#'   to `NULL`, in which case a label is not added.
#'
#' @param values A character string specifying a value for the checkbox,
#'   defaults to `NULL`, in which case the value of the checkbox is `NULL`.
#'
#' @param checked One of `TRUE` or `FALSE` specifying if the checkbox renders in
#'   the checked state, defaults to `FALSE`.
#'
#' @param inline If `TRUE`, the checkbox input is rendered inline, otherwise
#'   individual checkboxes are put on separate lines, defaults to `FALSE`.
#'
#' @param context One of `"success"`, `"warning"`, or `"danger"` specifying a
#'   visual context to add to a checkbox input, specifying `"none"` will remove
#'   any context on the checkbox, defaults to `NULL`. Whenever `NULL` the
#'   current checkbox context remains unchanged.
#'
#' @param disable One of `TRUE`, `FALSE`, or a value coercible to either
#'   specifying whether to disable or enable a checkbox input, by default
#'   checkbox inputs render in an enabled state, defaults to `NULL`. Whenever
#'   `NULL` the current state of the checkbox remains unchanged.
#'
#' @param ... Checkboxes passed to a checkbox input or additional named
#'   arguments passed on as HTML attributes to the respective parent element.
#'
#' @export
#' @examples
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkboxInput(
#'             id = "choices",
#'             checkbox("Choice 1", 1),
#'             checkbox("Choice 2", 2),
#'             checkbox("Choice 3", 3)
#'           ),
#'           button(
#'             id = "disable",
#'             label = "Disable / Enable"
#'           )
#'         ),
#'         col(
#'           checkboxInput(
#'             id = "options",
#'             checkbox("Option 1", 1),
#'             checkbox("Option 2", 2),
#'             checkbox("Option 3", 3)
#'           ),
#'           dropdownInput(
#'             id = "context",
#'             label = "Apply a context",
#'             dropdownItem("success", "success"),
#'             dropdownItem("warning", "warning"),
#'             dropdownItem("danger", "danger"),
#'             dropdownItem("none", "none")
#'           )
#'         )
#'       )
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         req(input$disable)
#'
#'         updateCheckbox("choices", disable = input$disable$count %% 2)
#'       })
#'
#'       observe({
#'         req(input$context)
#'
#'         updateCheckbox("options", context = input$context)
#'       })
#'     }
#'   )
#' }
#'
checkboxInput <- function(..., inline = FALSE, id = NULL) {
  tags$div(
    class = collate(
      "dull-checkbox-input",
      "dull-input",
      "form-group",
      if (!inline) "custom-controls-stacked"
    ),
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname checkboxInput
#' @export
checkbox <- function(label = NULL, value = NULL, checked = FALSE, ...) {
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
    ),
    ...
  )
}

#' @rdname checkboxInput
#' @export
updateCheckboxInput <- function(id, context = NULL, disable = NULL,
                           session = getDefaultReactiveDomain()) {
  if (!re(context, "success|warning|danger|none")) {
    stop(
      "invalid `updateCheckboxInput` argument, `context` must be one ",
      '"success", "warning", "danger", "none"',
      call. = FALSE
    )
  }

  session$sendInputMessage(
    id,
    list(
      disable = disable,
      context = context
    )
  )
}
