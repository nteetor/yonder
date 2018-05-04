---
layout: page
slug: progress-output
roxygen:
  rdname: ~
  name: progressOutput
  doctype: ~
  title: Progress bars
  description: |-
    Create simple or composite progress bars. To create a composite progress bar
    pass multiple calls to `bar` to a progress output. Each `bar` component has
    its own id, value, label, and attributes. Furthermore, utility functions may
    be applied to individual bars for added customization.
  parameters:
  - name: '...'
    description: |-
      One or more `bar` elements passed to a progress output or named
      arguments passed as HTML attributes to the parent element.
  - name: value
    description: |-
      An integer between 0 and 100 specifying the initial value
      of a bar.
  - name: label
    description: |-
      A character string specifying the label of a bar, defaults to
      `NULL`, in which case a label is not added.
  - name: striped
    description: |-
      If `TRUE`, the progress bar has a striped gradient, defaults
      to `FALSE`.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonInput(id = "inc", "Increment progress")
            ),
            col(
              progressOutput(
                bar("clicks", 0, striped = TRUE) %>%
                  background("blue", +2)
              )
            )
          )
        ),
        server = function(input, output) {
          observeEvent(input$inc, {
            sendBar(
              id = "clicks",
              value = min(input$inc / 20 * 100, 100)
            )
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              progressOutput(
                bar(id = "faster", value = 0) %>%
                  background("yellow"),
                bar(id = "slower", value = 0)
              )
            )
          )
        ),
        server = function(input, output) {
          observe({
            for (i in seq(from = 0, to = 50, by = 1)) {
              sendBar(
                id = "slower",
                value = i
              )

              sendBar(
                id = "faster",
                value = min(i * 3, 50)
              )

              Sys.sleep(0.1)
            }
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: progress.R
  source: |-
    progressOutput <- function(...) {
        tags$div(class = "dull-progress-output progress", ..., include("core"))
    }
---
