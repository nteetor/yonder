---
this: radioInput
filename: R/radio.R
layout: page
roxygen:
  title: Radio inputs
  description: Create a reactive radio input of one or more radio controls.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the radio input, the
      reactive value of the radio input is available to the shiny server
      function as part of the `input` object.
  - name: choices
    description: |-
      A character vector specifying labels for the radio input's
      choices.
  - name: values
    description: |-
      A character vector, list of character strings, vector of values
      to coerce to character strings, or list of values to coerce to character
      strings specifying the values of the radio input's choices, defaults to
      `choices`.
  - name: selected
    description: |-
      One of `values` indicating the default selected value of the
      radio input, defaults to `NULL`, in which case the first choice is
      selected by default.
  - name: help
    description: |-
      A character string specifying a small help label which appears
      below the input, defaults to `NULL` in which case help text is not added.
  - name: inline
    description: |-
      If `TRUE`, the radio input renders inline, defaults to `FALSE`,
      in which case the radio controls render on separate lines.
  - name: disabled
    description: |-
      One or more of `values` indicating which radio choices to
      disable, defaults to `NULL`, in which case all choices are enabled.
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
                radioInput(
                  id = "radio",
                  choices = c(
                    "(A) Ice cream",
                    "(B) Pumpkin pie",
                    "(C) 3 turtle doves",
                    "(D) (A) and (C)",
                    "(E) All of the above"
                  ),
                  values = LETTERS[1:5]
                )
              ),
              column(
                d4(
                  textOutput("selected")
                )
              )
            )
          ),
          server = function(input, output) {
            output$selected <- renderText({
              input$radio
            })
          }
        )
      }
    output: []
---
