---
layout: page
slug: group-input
roxygen:
  rdname: ~
  name: groupInput
  doctype: ~
  title: Group inputs, combination button, dropdown, and text input
  description: |-
    A group input is a combination reactive input which may consist of one or two
    buttons, dropdowns, static addons, or any combination of these elements.
    Static addons, specified with `left` and `right` may be used to ensure an
    group input's reactive value always has a certain prefix or suffix. These
    static addons render with a shaded background to help indicated this behavior
    to the user. Buttons and dropdowns may be included to control when the group
    input's reactive value updates. See Details for more information.
  parameters:
  - name: id
    description: A character string specifying the id of the group input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input group, defaults to `NULL`.
  - name: value
    description: |-
      A character string specifying an initial value for the input
      group, defaults to `NULL`.
  - name: left,right
    description: |-
      A character vector specifying static addons or
      [buttonInput()] or [dropdownInput()] elements specifying dynamic addons.
      Addon's affect the reactive value of the group input, see the Details
      section below for more information.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              groupInput(
                id = "buttongroup",
                left = "@",
                placeholder = "Username"
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
            input$buttongroup
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              groupInput(
                id = "groupinput",
                placeholder = "Search terms",
                right = buttonInput(
                  id = "button",
                  label = "Go!"
                )
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
            input$groupinput
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              groupInput(
                id = "groupinput",
                left = c("$", "0.")
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
            input$groupinput
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              groupInput(
                id = "groupinput",
                left = "@",
                placeholder = "Username",
                right = buttonInput(
                  id = "right",
                  label = "Search"
                ) %>%
                  background("white") %>%
                  border("blue")
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
            input$groupinput
          })
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: group.R
  source: "groupInput <- function(id, placeholder = NULL, value = NULL, \n    left
    = NULL, right = NULL, ...) {\n    if (!is.null(left) && !isValidAddon(left)) {\n
    \       stop(\"invalid `groupInput` argument, `left` must be a character string,
    \", \n            \"buttonInput(), or dropdownInput()\", call. = FALSE)\n    }\n
    \   if (!is.null(right) && !isValidAddon(right)) {\n        stop(\"invalid `groupInput`
    argument, `right` must be a character string, \", \n            \"buttonInput(),
    or dropdownInput()\", call. = FALSE)\n    }\n    shiny::registerInputHandler(type
    = \"dull.group.input\", fun = function(x, \n        session, name) paste0(x, collapse
    = \"\"), force = TRUE)\n    tags$div(class = \"dull-group-input input-group\",
    id = id, \n        if (!is.null(left)) {\n            tags$div(class = \"input-group-prepend\",
    if (is.character(left)) {\n                lapply(left, tags$span, class = \"input-group-text\")\n
    \           }\n            else if (tagHasClass(left, \"dull-dropdown-input\"))
    {\n                left$children\n            }\n            else {\n                left\n
    \           })\n        }, tags$input(type = \"text\", class = \"form-control\",
    \n            placeholder = placeholder, value = value), if (!is.null(right))
    {\n            tags$div(class = \"input-group-append\", if (is.character(right))
    {\n                lapply(right, tags$span, class = \"input-group-text\")\n            }\n
    \           else if (tagHasClass(right, \"dull-dropdown-input\")) {\n                right$children\n
    \           }\n            else {\n                right\n            })\n        },
    ...)\n}"
---
