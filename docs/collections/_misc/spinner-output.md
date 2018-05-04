---
layout: page
slug: spinner-output
roxygen:
  rdname: ~
  name: spinnerOutput
  doctype: ~
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
    description: A reactive context, defaults to [getDefaultReactiveDomain())].
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          col(
            spinnerOutput("spin", pulse = TRUE),
            buttonInput("trigger", "Start/stop")
          ) %>%
            display("flex") %>%
            content("around")
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
  aliases: ~
  family: ~
  export: yes
  filename: icons.R
  source: "spinnerOutput <- function(id, type = \"circle\", pulse = FALSE, \n    ...)
    {\n    tags$i(class = collate(\"dull-spinner-output\", \"fas\", switch(type, \n
    \       circle = \"fa-circle-notch\", cog = \"fa-cog\", dots = \"fa-spinner\",
    \n        sync = \"fa-sync\"), if (pulse) \n        \"fa-pulse\"\n    else \"fa-spin\",
    \"pause\"), id = id, ..., include(\"font awesome\"))\n}"
---
