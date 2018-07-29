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
#'
#' checkboxInput(
#'   id = "pellentesque",
#'   choice = "Cras placerat accumsan nulla"
#' )
#'
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       row(
#'         column(
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
#'         column(
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
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       checkboxInput("foo", "Hello, world!", "hello"),
#'       textOutput("checkvalue", inline = TRUE),
#'       textInput("label", placeholder = "New checkbox text"),
#'       textInput("value", placeholder = "New checkbox value"),
#'       tags$div(
#'         buttonInput("choices", "Update checkbox text"),
#'         buttonInput("values", "Update checkbox value")
#'       ) %>%
#'         display("flex")
#'     ),
#'     server = function(input, output) {
#'       output$checkvalue <- renderPrint({
#'         if (is.null(input$foo)) {
#'           markInvalid("foo", "Please check")
#'         } else {
#'           markValid("foo")
#'         }
#'
#'         input$foo
#'       })
#'
#'       observeEvent(input$choices, {
#'         req(input$label)
#'         updateChoices("foo", hello = input$label)
#'       })
#'
#'       observeEvent(input$values, {
#'         req(input$value, input$foo)
#'         updateValues("foo", !!(input$foo) := input$value)
#'       })
#'     }
#'   )
#' }
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
