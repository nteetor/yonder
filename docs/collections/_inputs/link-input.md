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
  source: "linkInput <- function(id, text, ...) {\n    shiny::registerInputHandler(type
    = \"dull.link\", fun = function(x, \n        session, name) {\n        if (x$value
    == 0) {\n            return(NULL)\n        }\n        id <- x$id\n        attr(id,
    \"clicks\") <- x$value\n        id\n    }, force = TRUE)\n    tags$span(class
    = \"dull-link-input\", id = id, tags$u(text), \n        ...)\n}"
---
