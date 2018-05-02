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
  source: "sliderInput <- function(id, choices, values = choices, selected = NULL,
    \n    ticks = TRUE, fill = FALSE, prefix = NULL, suffix = NULL) {\n    values
    <- vapply(values, as.character, character(1))\n    values <- encode_commas(values)\n
    \   choices <- encode_commas(choices)\n    selected <- encode_commas(selected)\n
    \   tags$div(class = \"dull-range-input bg-grey\", id = id, tags$input(class =
    \"range\", \n        type = \"text\", `data-type` = \"single\", `data-values`
    = paste0(values, \n            collapse = \",\"), `data-choices` = paste0(choices,
    \n            collapse = \",\"), `data-from` = if (!is.null(selected)) \n            which(choices
    == selected)[1] - 1, `data-prefix` = prefix, \n        `data-postfix` = suffix,
    `data-grid` = ticks, `data-hide-min-max` = TRUE, \n        `data-no-fill` = if
    (!fill) \n            \"true\"), include(\"core\"), include(\"ion slider\"))\n}"
---
