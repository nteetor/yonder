---
layout: page
slug: border
roxygen:
  rdname: background
  name: border
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    tags$h1("Hello, world!") %>%
      border("grey", sides = c("top", "bottom"))

    tags$div() %>%
      border("orange")

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              checkbarInput(
                id = NULL,
                choices = paste("Choice", 1:4)
              ) %>%
                background("cyan") %>%
                border("indigo")
            )
          )
        ),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - border <- function(tag, color, tone = 0) {
  - '  if (!(color %in% .colors)) {'
  - '    stop('
  - '      "invalid `border` argument, `color` is invalid, see ?border ",'
  - '      "details for possible colors", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!(tone %in% -2:2)) {'
  - '    stop('
  - '      "invalid `border` argument, `tone` must be one of -2, -1, 0, 1, or 2",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  tag <- tagAddClass(tag, "border")'
  - '  colorUtility(tag, "border", color, tone)'
  - '}'
---
