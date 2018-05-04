---
layout: page
slug: background
roxygen:
  rdname: ~
  name: background
  doctype: ~
  title: Change text, background, or border color
  description: |-
    The `text`, `background`, and `border` utility functions may be used to
    change the text, background, or border color of a tag element, respectively.
  parameters:
  - name: tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the background color, see details
      for all possible values.
  - name: tone
    description: |-
      An integer between -2 and 2 specifying to use a darker or lighter
      tone of `color`. Negative values indicate darker tones and positive values
      indicate lighter tones. Defaults to 0, in which case the base color is
      unchanged.
  sections: ~
  examples: |
    tags$div("light text, dark background") %>%
      background("grey", -2) %>%
      text("yellow", +1)

    if (interactive()) {
      opts <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green", "yellow",
        "amber", "orange", "brown", "grey"
      )

      shinyApp(
        ui = container(
          row(
            col(
              h5("Background"),
              selectInput(
                id = "bg",
                options = opts,
                selected = sample(opts, 1)
              ),
              rangeInput(
                id = "bgtone",
                min = -2,
                max = 2,
                default = 0,
                step = 1
              ) %>%
                margins(c(2, 0, 2, 0)),
              h5("Border"),
              selectInput(
                id = "border",
                options = opts,
                selected = sample(opts, 1)
              ),
              rangeInput(
                id = "bordertone",
                min = -2,
                max = 2,
                default = 0,
                step = 1
              ) %>%
                margins(c(2, 0, 2, 0)),
              h5("Text color"),
              selectInput(
                id = "text",
                options = opts,
                selected = sample(opts, 1)
              ),
              rangeInput(
                id = "texttone",
                min = -2,
                max = 2,
                default = 0,
                step = 1
              ) %>%
                margins(c(2, 0, 2, 0))
            ),
            col(
              uiOutput("preview") %>%
                margins(3) %>%
                padding(3)
            )
          )
        ),
        server = function(input, output) {
          output$preview <- renderUI({
            d3("Hello, world!") %>%
              background(input$bg, input$bgtone) %>%
              border(input$border, input$bordertone) %>%
              text(input$text, input$texttone)
          })
        }
      )
    }
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "background <- function(tag, color, tone = 0) {\n    if (color != \"transparent\"
    && !(color %in% .colors)) {\n        stop(\"invalid `background` argument, `color`
    is invalid, see ?background \", \n            \"details for possible colors\",
    call. = FALSE)\n    }\n    if (!(tone %in% -2:2)) {\n        stop(\"invalid `background`
    argument, `tone` must be one of -2, -1, 0, 1, or 2\", \n            call. = FALSE)\n
    \   }\n    if (color == \"transparent\") {\n        base <- \"bg\"\n    }\n    else
    if (tagHasClass(tag, \"alert\")) {\n        base <- \"alert\"\n    }\n    else
    if (tagHasClass(tag, \"badge\")) {\n        base <- \"badge\"\n    }\n    else
    if (tagHasClass(tag, \"btn\")) {\n        base <- \"btn\"\n    }\n    else if
    (tagHasClass(tag, \"list-group-item\")) {\n        base <- \"list-group-item\"\n
    \   }\n    else {\n        base <- \"bg\"\n    }\n    colorUtility(tag, base,
    color, tone)\n}"
---
