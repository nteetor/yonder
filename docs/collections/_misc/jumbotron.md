---
layout: page
slug: jumbotron
roxygen:
  rdname: ~
  name: jumbotron
  doctype: ~
  title: Jumbotron
  description: Highlight messages.
  parameters:
  - name: title
    description: A character string specifying the jumbotron's title.
  - name: subtitle
    description: A character string specifying the jumbotron's subtitle.
  - name: '...'
    description: |-
      Additional elements or named arguments passed as HTML attributes
      to the parent element.
  - name: fluid
    description: |-
      One of `TRUE` or `FALSE` specifying if the jumbotron fills the
      width of its parent container, defaults to `TRUE`, in which case the
      jumbotron fills the width of its parent container.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          jumbotron(
            title = "Hello, world!",
            subtitle = "This simple jumbotron-style component calls attention to a new feature",
            tags$p(
              "Here we can talk more about this excellently superb new feature.",
              "The best."
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: typography.R
  source:
  - jumbotron <- function(title, subtitle, ..., fluid = TRUE) {
  - '  tags$div(class = collate("jumbotron", if (fluid) {'
  - '    "jumbotron-fluid"'
  - '  } ), d3(title), tags$p('
  - '    class = "lead",'
  - '    subtitle'
  - '  ), if (length(elements(list(...))) > 0) {'
  - '    tags$hr(class = "my-4")'
  - '  } , ..., include("core"))'
  - '}'
---
