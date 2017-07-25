#' Radio inputs
#'
#' Create a reactive radio input of one or more radio controls.
#'
#' @param id A character string specifying the id of the radio input, defaults
#'   to `NULL`, in which case the radio element is rendered, but a reactive
#'   value is not passed to the shiny server function.
#'
#' @param label A character string specifying a label for the radio control,
#'   defaults to `NULL`, in which case a label is not added.
#'
#' @param value A character string specifying a value for the radio control,
#'   defaults to `NULL`, in which case the value of the radio is also `NULL`.
#'
#' @param checked One of `TRUE` or `FALSE` specifying if the radio control
#'   renders in a checked state, defaults to `FALSE`.
#'
#' @param inline If `TRUE`, the radio input renders inline, otherwise the
#'   radio controls render on separate lines, defaults to `FALSE`.
#'
#' @param ... Radio controls passed to a radio input or additional named
#'   arguments passed on to the respective parent element as HTML attributes.
#'
#' @family inputs
#' @export
#' @examples
#' if (interactive()) {
#'
#'
#' }
#'
radioInput <- function(..., inline = FALSE, id = NULL) {
  tags$div(
    class = collate(
      "dull-radio-input",
      "dull-input",
      "form-group",
      if (!inline) "custom-controls-stacked"
    ),
    ...,
    id = id,
    bootstrap()
  )
}

#' @rdname radioInput
#' @export
radio <- function(label = NULL, value = NULL, checked = FALSE, ...) {
  tags$label(
    class = collate(
      "custom-control",
      "custom-radio"
    ),
    tags$input(
      class = "custom-control-input",
      type = "radio",
      name = id,
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
}

#' @rdname radioInput
#' @export
updateRadioInput <- function(id, context = NULL, disable = NULL,
                             session = getDefaultReactiveDomain()) {
  if (!re(context, "success|warning|danger|none")) {
    stop(
      "invalid `updateRadioInput` argument, `context` must be one of ",
      '"success", "warning", "danger", or "none"',
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