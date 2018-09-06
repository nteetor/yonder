#' Checkbox inputs
#'
#' A reactive checkbox input. When a checkbox input is unchecked the reactive
#' value is `NULL`. When checked the checkbox input reactive value is `value`.
#' Unlike shiny, yonder's checkbox inputs are a singleton value.
#'
#' @param id A character string specifying the id of the checkbox input, the
#'   reactive value of the checkbox input is available to the shiny server
#'   function as part of the `input` object.
#'
#' @param choice A character string specifying a label for the checkbox.
#'
#' @param value A character string, object to coerce to a character string, or
#'   `NULL` specifying the value of the checkbox or a new value for the
#'   checkbox, defaults to `choice`.
#'
#' @param checked If `TRUE` the checkbox renders in a checked state, defaults
#'   to `FALSE`.
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @family inputs
#' @export
#' @examples
#'
#' ## Start checked
#'
#' checkboxInput(
#'   id = NULL,
#'   choice = "Suspendisse potenti",
#'   checked = TRUE
#' )
#'
checkboxInput <- function(id, choice, value = choice, checked = FALSE, ...) {
  if (length(choice) > 1) {
    stop(
      "invalid `checkboxInput()` argument, expecting `choice` to have a ",
      "length of 1",
      call. = FALSE
    )
  }

  value <- as.character(value)
  self <- ID("checkbox")

  tags$div(
    class = "yonder-checkbox",
    id = id,
    tags$div(
      class = collate(
        "custom-control",
        "custom-checkbox"
      ),
      tags$input(
        class = "custom-control-input",
        type = "checkbox",
        id = self,
        `data-value` = value,
        checked = if (checked) NA
      ),
      tags$label(
        class = "custom-control-label",
        `for` = self,
        choice
      ),
      tags$div(class = "invalid-feedback"),
      tags$div(class = "valid-feedback")
    ),
    ...,
    include("core")
  )
}
