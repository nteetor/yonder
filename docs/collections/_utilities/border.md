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
      border("grey")

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
  source: "border <- function(tag, color, tone = 0) {\n    if (!(color %in% .colors))
    {\n        stop(\"invalid `border` argument, `color` is invalid, see ?border \",
    \n            \"details for possible colors\", call. = FALSE)\n    }\n    if (!(tone
    %in% -2:2)) {\n        stop(\"invalid `border` argument, `tone` must be one of
    -2, -1, 0, 1, or 2\", \n            call. = FALSE)\n    }\n    tag <- tagAddClass(tag,
    \"border\")\n    colorUtility(tag, \"border\", color, tone)\n}"
---
