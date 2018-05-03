---
layout: page
slug: link-input
roxygen:
  rdname: buttonInput
  name: linkInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          "Curabitur ", linkInput("inline", "vulputate"), " vestibulum lorem."
        ),
        server = function(input, output) {
          observeEvent(input$inline, {
            showPopover(
              input$inline,
              content = "This means beef?",
              placement = "bottom"
            )
          })
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: button.R
  source:
  - linkInput <- function(id, text, ...) {
  - '  shiny::registerInputHandler(type = "dull.link", fun = function(x,'
  - '                                                                 session, name)
    {'
  - '    if (x$value == 0) {'
  - '      return(NULL)'
  - '    }'
  - '    id <- x$id'
  - '    attr(id, "clicks") <- x$value'
  - '    id'
  - '  }, force = TRUE)'
  - '  tags$span('
  - '    class = "dull-link-input", id = id, tags$u(text),'
  - '    ...'
  - '  )'
  - '}'
---
