---
this: checkbarInput
filename: R/bars.R
layout: page
roxygen:
  title: Check- and radiobar inputs
  description: |-
    Checkbar and radiobar inputs behave like the counter parts, checkbox and
    radio inputs. The -bar inputs are a stylistic variation. However, yonder
    checkbox inputs are singletons, thus the checkbar input is more akin to
    shiny's checkbox group input.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the check- or radiobar
      input.
  - name: choices
    description: |-
      A character vector or flat list of character strings
      specifying the labels of the check- or radiobar options.
  - name: values
    description: |-
      A character vector, flat list of character strings, or object
      to coerce to either, specifying the values of the check- or radiobar
      options, defaults to `choices`.
  - name: selected
    description: |-
      One or more of `values` indicating which of the check- or
      radiobar options are selected by default, defaults to `NULL`, in which case
      there is no default option.
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
                checkbarInput(
                  id = "blue",
                  choices = c(
                    "Check 1",
                    "Check 2",
                    "Check 3"
                  ),
                  selected = "Check 1"
                ) %>%
                  background("blue") %>%
                  margin(2),
               checkbarInput(
                  id = "indigo",
                  choices = c(
                    "Check 1",
                    "Check 2",
                    "Check 3"
                  ),
                  selected = "Check 2"
                ) %>%
                  background("indigo") %>%
                  margin(2)
              ),
              column(
                verbatimTextOutput("values")
              )
            )
          ),
          server = function(input, output) {
            output$values <- renderPrint({
              list(
                `blue` = input$blue,
                indigo = input$indigo
              )
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                radiobarInput(
                  id = "radiobar",
                  choices = c(
                    "Radio 1",
                    "Radio 2",
                    "Radio 3"
                  ),
                  selected = "Radio 1"
                ) %>%
                  background("blue")
              ),
              column(
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderPrint({
              input$radiobar
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            checkbarInput("foo", c("hello, world!", "goodnight, moon"), c("world", "moon")),
            textOutput("selected"),
            buttonInput("labels", "Change labels"),
            buttonInput("values", "Change values")
          ),
          server = function(input, output) {
            output$selected <- renderPrint({
              input$foo
            })
            observeEvent(input$labels, {
              updateChoices("foo", world = "goodbye, world!", moon = "morning, moon")
            })
            observeEvent(input$values, {
              updateValues("foo", world = "planet", moon = "spacestation")
            })
          }
        )
      }
    output: []
---
