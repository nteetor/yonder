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
#' @param choice,choices A character string or vector specifying a label for the
#'   checkbox or checkbar.
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
#' ### Start checked
#'
#' checkboxInput(
#'   id = NULL,
#'   choice = "Suspendisse potenti",
#'   checked = TRUE
#' )
#'
#' ### An alternative to checkbox groups
#'
#' checkbarInput(
#'   id = NULL,
#'   choices = c(
#'     "Check 1",
#'     "Check 2",
#'     "Check 3"
#'   ),
#'   selected = "Check 1"
#' ) %>%
#'   background("blue") %>%
#'   margin(2)
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

  input <- tags$div(
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
    ...
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}

#' @rdname checkboxInput
#' @export
checkbarInput <- function(id, choices, values = choices, selected = NULL) {
  if (length(choices) != length(values)) {
    stop(
      "invalid `checkbarInput` arguments, `choices` and `values` must have ",
      "the same length",
      call. = FALSE
    )
  }

  selected <- match2(selected, values)

  input <- tags$div(
    class = collate(
      "yonder-checkbar",
      if (length(choices) > 1) "btn-group",
      "btn-group-toggle"
    ),
    `data-toggle` = "buttons",
    id = id,
    lapply(
      seq_along(choices),
      function(i) {
        tags$label(
          class = collate(
            "btn",
            if (selected[[i]]) "active"
          ),
          tags$input(
            type = "checkbox",
            autocomplete = "off",
            `data-value` = values[[i]],
            checked = if (selected[[i]]) NA
          ),
          tags$span(
            choices[[i]]
          )
        )
      }
    )
  )

  input <- attachDependencies(
    input,
    c(shinyDep(), yonderDep(), bootstrapDep())
  )

  input
}
