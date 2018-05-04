---
layout: page
slug: stream-output
roxygen:
  rdname: ~
  name: streamOutput
  doctype: ~
  title: Stream notifications
  description: |-
    The stream output is used to send updates to the user during long-running
    processes. Unlike conventional reactive outputs, the stream output does not
    have a render function instead messages are sent with `sendStreamMessage`.
    This allows message to "render" during long-running observers or other
    processes.
  parameters:
  - name: id
    description: A character string specifying the id of the stream output.
  - name: content
    description: A character string specifying the message text.
  - name: session
    description: |-
      A `session` object passed to the shiny server function,
      defaults to [getDefaultReactiveDomain()].
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonInput(id = "trigger", "Go!")
            ),
            col(
              streamOutput(
                id = "stream"
              )
            )
          )
        ),
        server = function(input, output, session) {
          observeEvent(input$trigger, {
            for (i in seq_len(5)) {
              sendStream(
                id = "stream",
                content = paste("Update:", i)
              )
              Sys.sleep(1)
            }
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: stream.R
  source: "streamOutput <- function(id, ...) {\n    tags$ul(class = collate(\"dull-stream-output\",
    \"list-group\"), \n        id = id, ...)\n}"
---
