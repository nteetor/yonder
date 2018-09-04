---
this: linkInput
filename: R/button.R
layout: page
roxygen:
  title: Button and submit inputs
  description: |-
    Button inputs are useful as triggers for reactive or observer expressions.
    The reactive value of a button input is the number of times it has been
    clicked.

    A submit input is a special type of button used to control HTML form
    submission. Unlike shiny's `submitButton`, `submitInput` will not freeze all
    reactive inputs on the page.
  parameters:
  - name: id
    description: A character string specifying the id of the button or link input.
  - name: label
    description: |-
      A character string specifying the label text on the button
      input.
  - name: block
    description: |-
      If `TRUE`, the input is block-level instead of inline, defaults
      to `FALSE`. A block-level element will occupy the entire width of its
      parent element.
  - name: text
    description: |-
      A character string specifying the text displayed as part of the
      link input.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                buttonInput(
                  id = "button",
                  label = "Click me!"
                ) %>%
                  background("green")
              ),
              column(
                d4(
                  textOutput("clicks")
                )
              )
            )
          ),
          server = function(input, output) {
            output$clicks <- renderText({
              input$button
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            center = TRUE,
            buttonInput(
              id = "button",
              label = list(
                "Increment badge",
                badgeOutput(
                  id = "badge"
                ) %>%
                  background("green")
              )
            ) %>%
              background("amber")
          ),
          server = function(input, output) {
            output$badge <- renderBadge({
              input$button
            })
          }
        )
      }
    output: []
---
