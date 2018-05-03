---
layout: page
slug: slider-input
roxygen:
  rdname: rangeInput
  name: sliderInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          sliderInput(
            "slide",
            choices = c("hello, world", "goodnight, moon", "greetings, earthlings"),
            values = c("hello", "goodnight", "greetings"),
            selected = "goodnight, moon"
          )
        ),
        server = function(input, output) {
          observe({
            print(input$slide)
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: range.R
  source:
  - sliderInput <- function(id, choices, values = choices, selected = NULL,
  - '                        ticks = TRUE, fill = FALSE, prefix = NULL, suffix = NULL)
    {'
  - '  values <- vapply(values, as.character, character(1))'
  - '  values <- encode_commas(values)'
  - '  choices <- encode_commas(choices)'
  - '  selected <- encode_commas(selected)'
  - '  tags$div(class = "dull-range-input bg-grey", id = id, tags$input('
  - '    class = "range",'
  - '    type = "text", `data-type` = "single", `data-values` = paste0('
  - '      values,'
  - '      collapse = ","'
  - '    ), `data-choices` = paste0('
  - '      choices,'
  - '      collapse = ","'
  - '    ), `data-from` = if (!is.null(selected)) {'
  - '      which(choices == selected)[1] - 1'
  - '    } , `data-prefix` = prefix,'
  - '    `data-postfix` = suffix, `data-grid` = ticks, `data-hide-min-max` = TRUE,'
  - '    `data-no-fill` = if (!fill) {'
  - '      "true"'
  - '    }'
  - '  ), include("core"), include("ion slider"))'
  - '}'
---
