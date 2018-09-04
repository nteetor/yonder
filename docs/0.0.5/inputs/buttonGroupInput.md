---
this: buttonGroupInput
filename: R/button.R
layout: page
roxygen:
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
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      buttonGroupInput("group", c("Once", "Twice"), c(1, 2))
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                buttonGroupInput(
                  id = "group",
                  labels = c("Once", "Twice", "Thrice"),
                  values = c(1, 2, 3)
                )
              ),
              column(
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
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                buttonGroupInput(
                  id = "bg1",
                  labels = c("Button 1", "Button 2", "Button 3")
                ) %>%
                  background("blue") %>%
                  margin(3)
              ),
              column(
                buttonGroupInput(
                  id = "bg2",
                  labels = c("Groupee 1", "Groupee 2", "Groupee 3")
                ) %>%
                  background("yellow") %>%
                  margin(3)
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
    output:
    - |-
      <div class="yonder-button-group btn-group" id="group" role="group">
        <button type="button" class="btn" data-value="1">Once</button>
        <button type="button" class="btn" data-value="2">Twice</button>
      </div>
---
