---
layout: page
slug: button-group-input
roxygen:
  rdname: ~
  name: buttonGroupInput
  doctype: ~
  title: Button group inputs
  description: Groups of buttons with a persisting value.
  parameters:
  - name: id
    description: A character string specifying the id of the button group input.
  - name: labels
    description: |-
      A character vector of labels, a button is added to the group
      for each label specified.
  - name: values
    description: |-
      A character vector of values, one for each button specified,
      defaults to `labels`.
  sections: ~
  examples:
  - buttonGroupInput("group", c("Once", "Twice"), c(1, 2))
  - |-
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonGroupInput(
                id = "group",
                labels = c("Once", "Twice", "Thrice"),
                values = c(1, 2, 3)
              )
            ),
            col(
              verbatimTextOutput("value")
            )
          )
        ),
        server = function(input, output) {
          output$value <- renderPrint({
            input$group
          })
        }
      )
    }
  - |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonGroupInput(
                id = "bg1",
                labels = c("Button 1", "Button 2", "Button 3")
              ) %>%
                background("blue", -2) %>%
                margins(3)
            ),
            col(
              buttonGroupInput(
                id = "bg2",
                labels = c("Groupee 1", "Groupee 2", "Groupee 3")
              ) %>%
                background("yellow", +1) %>%
                margins(3)
            )
          )
        ),
        server = function(input, output) {
          observe({
            print(input$bg1)
          })

          observe({
            print(input$bg2)
          })
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: button.R
  source:
  - buttonGroupInput <- function(id, labels, values = labels) {
  - '  if (length(labels) != length(values)) {'
  - '    stop('
  - '      "invalid `buttonGroupInput` arguments, `labels` and `values` must be ",'
  - '      "the same length", call. = FALSE'
  - '    )'
  - '  }'
  - '  tags$div('
  - '    class = "dull-button-group-input btn-group", id = id,'
  - '    role = "group", Map(label = labels, value = values, function(label,'
  - '                                                                 value, outline)
    {'
  - '      tags$button('
  - '        type = "button", class = "btn", `data-value` = value,'
  - '        label'
  - '      )'
  - '    }), include("core")'
  - '  )'
  - '}'
---
