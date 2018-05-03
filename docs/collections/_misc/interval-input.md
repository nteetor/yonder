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
  source:
  - intervalInput <- function(id, min = 0, max = 100, default = c(
  - '                          min,'
  - '                          max'
  - '                        ), step = 1, draggable = FALSE, ticks = TRUE, labels
    = 4,'
  - '                        snap = FALSE, prefix = NULL, suffix = NULL) {'
  - '  tags$div(class = "dull-range-input bg-grey", id = id, tags$input('
  - '    class = "range",'
  - '    type = "text", `data-type` = "double", `data-min` = min,'
  - '    `data-max` = max, `data-from` = default[1], `data-to` = default[2],'
  - '    `data-drag-interval` = draggable, `data-prettify-separator` = ",",'
  - '    `data-prefix` = prefix, `data-postfix` = suffix, `data-grid` = ticks,'
  - '    `data-grid-num` = labels, `data-grid-snap` = if (isTRUE(snap)) {'
  - '      snap'
  - '    }'
  - '  ), include("core"), include("ion slider"))'
  - '}'
---
