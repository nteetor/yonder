#' Checkbox inputs
#'
#' A reactive checkbox input. When a checkbox input is unchecked the reactive
#' value is `NULL`. When checked the checkbox input reactive value is `value`.
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
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         col(
#'           checkboxInput(
#'             id = "checkbox",
#'             choice = "Are you there?",
#'             value = "yes"
#'           ),
#'           checkboxInput(
#'             id = "hello",
#'             choice = "Hello"
#'           )
#'         ),
#'         col(
#'           d4(
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
#'             choice = "Capslock?",
#'             value = "capslock"
#'           )
#'         ),
#'         col(
#'           checkboxInput(
#'             id = "question",
#'             choice = "Please check this box",
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
#'             choice = "PLEASE CHECK THIS BOX",
#'             value = "checked"
#'           )
#'         } else {
#'           updateCheckboxInput(
#'             id = "question",
#'             choice = "Please check this box",
#'             value = "checked"
#'           )
#'         }
#'       })
#'     }
#'   )
#' }
#'
checkboxInput <- function(id, choice, value = choice, checked = FALSE, ...) {
  value <- as.character(value)

  tags$div(
    class = collate(
      "dull-checkbox-input",
      "dull-input",
      "form-group"
    ),
    id = id,
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
        choice
      ),
      tags$div(class = "invalid-feedback")
    ),
    ...,
    includes()
  )
}

#' @rdname checkboxInput
#' @export
updateCheckboxInput <- function(id, choice, value = choice, checked = FALSE,
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
      choice
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
