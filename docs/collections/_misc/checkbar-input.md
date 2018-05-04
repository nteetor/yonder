---
layout: page
slug: checkbar-input
roxygen:
  rdname: ~
  name: checkbarInput
  doctype: ~
  title: Check- and radiobar inputs
  description: |-
    Checkbar and radiobar inputs behave like the counter parts, checkbox and
    radio inputs. The -bar inputs are a stylistic variation. However, dull
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
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
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
                margins(2),
             checkbarInput(
                id = "indigo",
                choices = c(
                  "Check 1",
                  "Check 2",
                  "Check 3"
                ),
                selected = "Check 2"
              ) %>%
                background("indigo", +1) %>%
                margins(2)
            ),
            col(
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
            col(
              radiobarInput(
                id = "radiobar",
                choices = c(
                  "Radio 1",
                  "Radio 2",
                  "Radio 3"
                ),
                selected = "Radio 1"
              )
            ),
            col(
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
  aliases: ~
  family: ~
  export: yes
  filename: bars.R
  source: "checkbarInput <- function(id, choices, values = choices, selected = NULL)
    {\n    if (length(choices) != length(values)) {\n        stop(\"invalid `checkbarInput`
    arguments, `choices` and `values` must have \", \n            \"the same length\",
    call. = FALSE)\n    }\n    selected <- match2(selected, values)\n    tags$div(class
    = collate(\"dull-checkbar-input\", if (length(choices) > \n        1) \n        \"btn-group\",
    \"btn-group-toggle\"), `data-toggle` = \"buttons\", \n        id = id, lapply(seq_along(choices),
    function(i) {\n            tags$label(class = collate(\"btn\", if (selected[[i]])
    \n                \"active\"), tags$input(type = \"checkbox\", autocomplete =
    \"off\", \n                `data-value` = values[[i]], checked = if (selected[[i]])
    \n                  NA), tags$span(choices[[i]]))\n        }))\n}"
---
