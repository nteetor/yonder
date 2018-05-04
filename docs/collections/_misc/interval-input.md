---
layout: page
slug: interval-input
roxygen:
  rdname: rangeInput
  name: intervalInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          intervalInput("gray") %>%
            margins(c(0, 0, 4, 0)),
          intervalInput("green", default = c(25, 75), draggable = TRUE)
        ),
        server = function(input, output) {
          observe({
            print(input$green)
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: range.R
  source: "intervalInput <- function(id, min = 0, max = 100, default = c(min, \n    max),
    step = 1, draggable = FALSE, ticks = TRUE, labels = 4, \n    snap = FALSE, prefix
    = NULL, suffix = NULL) {\n    tags$div(class = \"dull-range-input bg-grey\", id
    = id, tags$input(class = \"range\", \n        type = \"text\", `data-type` = \"double\",
    `data-min` = min, \n        `data-max` = max, `data-from` = default[1], `data-to`
    = default[2], \n        `data-drag-interval` = draggable, `data-prettify-separator`
    = \",\", \n        `data-prefix` = prefix, `data-postfix` = suffix, `data-grid`
    = ticks, \n        `data-grid-num` = labels, `data-grid-snap` = if (isTRUE(snap))
    \n            snap), include(\"core\"), include(\"ion slider\"))\n}"
---
