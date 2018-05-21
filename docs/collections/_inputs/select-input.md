---
layout: page
slug: select-input
roxygen:
  rdname: ~
  name: selectInput
  doctype: ~
  title: Select input
  description: |-
    Create a select input. Select elements often appear as a dropdown menu and
    may have one or more selected values, see `multiple`.
  parameters:
  - name: id
    description: A character string specifying the id of the select input.
  - name: choices
    description: |-
      A character vector specifying the labels of the select input
      options.
  - name: values
    description: |-
      A character vector specifying the values of the select input
      options, defaults to `chocies`.
  - name: selected
    description: |-
      One of `values` indicating the default value of the select
      input, defaults to `NULL`. If `NULL` the first value is selected by
      default.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` multiple values may be
      selected, otherwise a single value is selected at a time,
      defaults to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  examples: |+
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              selectInput(
                id = "select",
                choices = c("Choose one", "One", "Two", "Three"),
                values = list(NULL, 1, 2, 3),
                multiple = TRUE
              )
            ),
            column(
              d4(
                textOutput("value")
              )
            )
          )
        ),
        server = function(input, output) {
          output$value <- renderText({
            input$select
          })
        }
      )
    }

  aliases: ~
  family: inputs
  export: yes
  filename: select.R
  source: "selectInput <- function(id, choices, values = choices, selected = NULL,
    \n    multiple = FALSE, ...) {\n    if (!is.null(id) && !is.character(id)) {\n
    \       stop(\"invalid `selectInput` argument, `id` must be a character string
    or NULL\", \n            call. = FALSE)\n    }\n    if (length(choices) != length(values))
    {\n        stop(\"invalid `selectInput` arguments, `choices` and `values` must
    be the \", \n            \"same length\", call. = FALSE)\n    }\n    if (!is.null(selected))
    {\n        if (length(selected) > 1) {\n            stop(\"invalid `selectInput`
    argument, `selected` must be of length 1\", \n                call. = FALSE)\n
    \       }\n        if (!(selected %in% values)) {\n            stop(\"invalid
    `selectInput` argument, `selected` must be one of `values`\", \n                call.
    = FALSE)\n        }\n    }\n    selected <- match2(selected, values, default =
    TRUE)\n    tags$div(class = \"dull-select-input\", id = id, tags$select(class
    = \"custom-select\", \n        lapply(seq_along(choices), function(i) {\n            tags$option(`data-value`
    = values[[i]], choices[[i]], \n                selected = if (selected[[i]]) \n
    \                 NA)\n        }), multiple = if (multiple) \n            NA),
    tags$div(class = \"invalid-feedback\"), ..., include(\"core\"))\n}"
---
