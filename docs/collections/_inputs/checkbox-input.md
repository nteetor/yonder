---
layout: page
slug: checkbox-input
roxygen:
  rdname: ~
  name: checkboxInput
  doctype: ~
  title: Checkbox inputs
  description: |-
    A reactive checkbox input. When a checkbox input is unchecked the reactive
    value is `NULL`. When checked the checkbox input reactive value is `value`.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the checkbox input, the
      reactive value of the checkbox input is available to the shiny server
      function as part of the `input` object.
  - name: choice
    description: A character string specifying a label for the checkbox.
  - name: value
    description: |-
      A character string, object to coerce to a character string, or
      `NULL` specifying the value of the checkbox or a new value for the
      checkbox, defaults to `choice`.
  - name: checked
    description: |-
      If `TRUE` the checkbox renders in a checked state, defaults
      to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  examples:
  - |-
    checkboxInput(
      id = "pellentesque",
      choice = "Cras placerat accumsan nulla"
    )
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              checkboxInput(
                id = "checkbox",
                choice = "Are you there?",
                value = "yes"
              ),
              checkboxInput(
                id = "hello",
                choice = "Hello"
              )
            ),
            column(
              d4(
                textOutput("value")
              )
            )
          )
        ),
        server = function(input, output) {
          output$value <- renderText({
            input$checkbox
          })
        }
      )
    }
  - |
    if (interactive()) {
      shinyApp(
        ui = container(
          checkboxInput("foo", "Hello, world!", "hello"),
          textOutput("checkvalue", inline = TRUE),
          textInput("label", placeholder = "New checkbox text"),
          textInput("value", placeholder = "New checkbox value"),
          tags$div(
            buttonInput("choices", "Update checkbox text"),
            buttonInput("values", "Update checkbox value")
          ) %>%
            display(flex = TRUE)
        ),
        server = function(input, output) {
          output$checkvalue <- renderPrint({
            if (is.null(input$foo)) {
              markInvalid("foo", "Please check")
            } else {
              markValid("foo")
            }

            input$foo
          })

          observeEvent(input$choices, {
            req(input$label)
            updateChoices("foo", hello = input$label)
          })

          observeEvent(input$values, {
            req(input$value, input$foo)
            updateValues("foo", !!(input$foo) := input$value)
          })
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: checkbox.R
  source: "checkboxInput <- function(id, choice, value = choice, checked = FALSE,
    \n    ...) {\n    value <- as.character(value)\n    self <- ID(\"checkbox\")\n
    \   tags$div(class = \"dull-checkbox-input\", id = id, tags$div(class = collate(\"custom-control\",
    \n        \"custom-checkbox\"), tags$input(class = \"custom-control-input\", \n
    \       type = \"checkbox\", id = self, `data-value` = value, checked = if (checked)
    \n            NA), tags$label(class = \"custom-control-label\", `for` = self,
    \n        choice), tags$div(class = \"invalid-feedback\"), tags$div(class = \"valid-feedback\")),
    \n        ..., include(\"core\"))\n}"
---
