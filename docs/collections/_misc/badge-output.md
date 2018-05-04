---
layout: page
slug: badge-output
roxygen:
  rdname: ~
  name: badgeOutput
  doctype: ~
  title: Badge outputs
  description: |-
    Small highlighted content which scales to its parent's size. Useful for
    displaying dynamically changing counts or tickers, drawing attention to new
    options, or tagging content.
  parameters:
  - name: id
    description: A character string specifying the id of the badge output.
  - name: content
    description: |-
      A character string specifying the content of the badge or an
      expression which returns a character string.
  - name: env
    description: The environment in which to evaluate `content`.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `content` is a quoted
      expression.
  - name: '...'
    description: |-
      Additional named argument passed as HTML attributes to the parent
      element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonInput(
                id = "button",
                label = list(
                  "Number of clicks: ",
                  badgeOutput("clicks", 0) %>%
                    background("red", -2)
                )
              )
            )
          )
        ),
        server = function(input, output) {
          output$clicks <- renderBadge({
            input$button
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: badge.R
  source: "badgeOutput <- function(id, content, ...) {\n    if (!is.character(id))
    {\n        stop(\"invalid `badgeOutput` argument, `id` must be a character string\",
    \n            call. = FALSE)\n    }\n    tags$span(class = \"dull-badge-output
    badge\", id = id, content, \n        ...)\n}"
---
