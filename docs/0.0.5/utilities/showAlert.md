---
this: showAlert
filename: R/alerts.R
layout: page
roxygen:
  title: Static and actionable alerts
  description: |-
    Use `showAlert` to let the user know of successes or to call attention to
    problems. While alerts are static by default they can also be made
    actionable. Actionable alerts can be used for undoing or redoing an action
    and more.
  parameters:
  - name: text
    description: A character string specifying the message text of the alert.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      alert element.
  - name: duration
    description: |-
      A positive integer or `NULL` specifying the duration of the
      alert, by default the alert is removed after 4 seconds. If `NULL` the
      alert is not automatically removed.
  - name: color
    description: |-
      A character string specifying the color of the alert,
      for possible colors see [background](/yonder/0.0.5/background.html).
  - name: action
    description: |-
      A character string specifying a reactive id. If specified a
      button is added to the alert. If clicked the reactive value
      `input[[action](/yonder/0.0.5/[action.html)]` is set to `TRUE`. When the alert is removed
      `input[[action](/yonder/0.0.5/[action.html)]` is reset to `NULL`.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - type: source
    value: |2-


      if (interactive()) {
        shinyApp(
          ui = container(
            buttonInput("show", "Alert!") %>%
              margin(3)
          ),
          server = function(input, output) {
            observeEvent(input$show, {
              color <- sample(c("teal", "red", "orange", "blue"), 1)
              showAlert("Alert", color = color)
            })
          }
        )
      }

      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                groupInput(
                  id = "text",
                  right = buttonInput("clear", icon("times")) %>%
                    background("red")
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            ) %>%
              margin(3)
          ),
          server = function(input, output) {
            oldValue <- NULL

            output$value <- renderPrint(input$text)

            observeEvent(input$clear, {
              oldValue <<- input$text
              updateValues("text", "")
              showAlert("Undo clear.", color = "yellow", action = "undo")
            })

            observeEvent(input$undo, {
              updateValues("text", oldValue)
            })
          }
        )
      }
  - type: code
    value:
    - |-
      if (interactive()) {
          shinyApp(ui = container(buttonInput("show", "Alert!") %>% margin(3)), server = function(input, output) {
              observeEvent(input$show, {
                  color <- sample(c("teal", "red", "orange", "blue"), 1)
                  showAlert("Alert", color = color)
              })
          })
      }
    - |-
      if (interactive()) {
          shinyApp(ui = container(row(column(groupInput(id = "text", right = buttonInput("clear", icon("times")) %>% background("red"))), column(verbatimTextOutput("value"))) %>% margin(3)), server = function(input, output) {
              oldValue <- NULL
              output$value <- renderPrint(input$text)
              observeEvent(input$clear, {
                  oldValue <<- input$text
                  updateValues("text", "")
                  showAlert("Undo clear.", color = "yellow", action = "undo")
              })
              observeEvent(input$undo, {
                  updateValues("text", oldValue)
              })
          })
      }
---
