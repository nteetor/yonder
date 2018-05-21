---
layout: page
slug: radio-input
roxygen:
  rdname: ~
  name: radioInput
  doctype: ~
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
  examples: |
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
  aliases: ~
  family: inputs
  export: yes
  filename: radio.R
  source: "radioInput <- function(id, choices, values = choices, selected = NULL,
    \n    disabled = NULL, help = NULL, inline = FALSE) {\n    if (!is.null(selected)
    && !(selected %in% values)) {\n        stop(\"invalid `radioInput` argument, `selected`
    must be one of `values`\", \n            call. = FALSE)\n    }\n    if (!is.null(disabled)
    && !(disabled %in% values)) {\n        stop(\"invalid `radioInput` argument, `disabled`
    must be one of `values`\", \n            call. = FALSE)\n    }\n    if (length(choices)
    != length(values)) {\n        stop(\"invalid `radioInput` arguments, `choices`
    and `values` must be the same \", \n            \"length\", call. = FALSE)\n    }\n
    \   selected <- match2(selected, values, default = TRUE)\n    disabled <- match2(disabled,
    values)\n    ids <- ID(rep.int(\"radio\", length(choices)))\n    tags$div(class
    = \"dull-radio-input\", id = id, if (!is.null(choices)) {\n        lapply(seq_along(choices),
    function(i) {\n            tags$div(class = collate(\"custom-control\", \"custom-radio\",
    \n                if (inline) \n                  \"custom-control-inline\"),
    tags$input(class = \"custom-control-input\", \n                type = \"radio\",
    id = ids[[i]], name = id, `data-value` = values[[i]], \n                checked
    = if (selected[[i]]) \n                  NA, disabled = if (disabled[[i]]) \n
    \                 NA), tags$label(class = \"custom-control-label\", \n                `for`
    = ids[[i]], choices[[i]]))\n        })\n    }, tags$div(class = \"invalid-feedback\"),
    if (!is.null(help)) {\n        tags$small(class = \"form-text text-muted\", help)\n
    \   }, include(\"core\"))\n}"
---
