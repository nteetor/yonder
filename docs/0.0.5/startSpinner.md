---
this: startSpinner
filename: R/icons.R
layout: page
roxygen:
  title: A spinner
  description: Start or stop a spinner based on process progress.
  parameters:
  - name: id
    description: A character specifying the id of the spinner output.
  - name: type
    description: |-
      One of `"circle"`, `"cog"`, `"dots"`, or `"sync"` specifying the
      type of spinner, defaults to `"circle"`.
  - name: pulse
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` the spinner rotates in 8
      discrete steps, defaults to `FALSE`.
  - name: '...'
    description: |-
      Additional named argument passed as HTML attributes to the
      parent element.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain())](/yonder/0.0.5/getDefaultReactiveDomain()).html).
  sections: ~
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples:
  - type: source
    value: |2-

      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                spinnerOutput("spin", pulse = TRUE),
                buttonInput("trigger", "Start/stop")
              ) %>%
                display("flex") %>%
                flex(justify = "around")
            )
          ),
          server = function(input, output) {
            observeEvent(input$trigger, {
              if (input$trigger %% 2 == 1) {
                startSpinner("spin")
              } else {
                stopSpinner("spin")
              }
            })
          }
        )
      }
  - type: code
    value: |-
      if (interactive()) {
          shinyApp(ui = container(row(column(spinnerOutput("spin", pulse = TRUE), buttonInput("trigger", "Start/stop")) %>% display("flex") %>% flex(justify = "around"))), server = function(input, output) {
              observeEvent(input$trigger, {
                  if (input$trigger%%2 == 1) {
                      startSpinner("spin")
                  }
                  else {
                      stopSpinner("spin")
                  }
              })
          })
      }
---
