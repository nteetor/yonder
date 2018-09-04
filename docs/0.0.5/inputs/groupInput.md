---
this: groupInput
filename: R/group.R
layout: page
roxygen:
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
      [buttonInput()](/yonder/0.0.5/buttonInput().html) or [dropdown()](/yonder/0.0.5/dropdown().html) elements specifying dynamic addons.
      Addon's affect the reactive value of the group input, see the Details
      section below for more information.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      parent element.
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
                    background("transparent") %>%
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
    output: []
---
