---
layout: page
slug: collapse
roxygen:
  rdname: ~
  name: collapse
  doctype: ~
  title: Collapsible sections
  description: |-
    `collapse` allows content to be hidden and toggled into a shown state.
    The collapsed content is toggled by a button or may be toggled between hidden
    and shown states using `toggleCollapse`. `showCollapse` and `hideCollapse`
    are alternatives to `toggleCollapse` to change the state of collapsed content
    to shown or hidden, respectively.
  parameters:
  - name: button
    description: |-
      A button input, when clicked the button will hide or show the
      collapsable content.
  - name: '...'
    description: |-
      Additional named arguments passed as attributes to the parent
      element.
  - name: id
    description: A character string specifying the id of a collapse section.
  - name: session
    description: |-
      A `session` object passed to the shiny server function,
      defaults to [`getDefaultReactiveDomain()`].
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              buttonInput(
                id = "trigger",
                label = "The Time Machine"
              ) %>%
                background("purple", +1) %>%
                margins(2) %>%
                collapse(
                  tags$div(
                    class  = "card card-block",
                    "\"The Time Traveller (for so it will be convenient to speak
                    of him) was expounding a recondite matter to us. His grey eyes
                    shone and twinkled, and his usually pale face was flushed and
                    animated. The fire burned brightly, and the soft radiance of
                    the incandescent lights in the lilies of silver caught the
                    bubbles that flashed and passed in our glasses.\""
                  )
                )
            ),
            col(
              buttonInput(id = "toggle", "Toggle"),
              buttonInput(id = "hide", "Hide"),
              buttonInput(id = "show", "Show")
            )
          )
        ),
        server = function(input, output) {
          observeEvent(input$toggle, {
            toggleCollapse("trigger")
          })

          observeEvent(input$hide, {
            hideCollapse("trigger")
          })

          observeEvent(input$show, {
            showCollapse("trigger")
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: collapse.R
  source: "collapse <- function(button, content, ...) {\n    id <- ID(\"collapse\")\n
    \   tags$div(`aria-expanded` = \"false\", tagAppendAttributes(button, \n        `data-toggle`
    = \"collapse\", `data-target` = paste0(\"#\", \n            id), `aria-controls`
    = id), tags$div(class = \"collapse\", \n        id = id, content), ..., include(\"core\"))\n}"
---
