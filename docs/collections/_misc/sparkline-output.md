---
layout: page
slug: sparkline-output
roxygen:
  rdname: ~
  name: sparklineOutput
  doctype: ~
  title: Sparkline output
  description: Display concise, reactive inline bar, line, or dot charts.
  parameters:
  - name: id
    description: A character string specifying the id of the sparkline output.
  - name: type
    description: |-
      One of `"bar"`, `"dot"`, or `"line"` specifying the type of
      chart to render, defaults to `"bar"`.
  - name: labels
    description: |-
      If `TRUE`, the first and last value of the sparkline data
      are used as labels, defaults to `TRUE`.
  - name: values
    description: |-
      A numeric vector of values specifying the sparkline data
      points. Bar and dot sparklines expect values to be between 0 and 100 and
      line sparklines expect values to be between 0 and 10.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              listGroupInput(
                id = "toc",
                items = list(
                  tags$div(
                    class = "d-flex w-100 justify-content-between",
                    "Bars",
                    sparklineOutput("bar", type = "bar")
                  ),
                  tags$div(
                    class = "d-flex w-100 justify-content-between",
                    "Dots",
                    sparklineOutput("dot", type = "dot")
                  ),
                  tags$div(
                    class = "d-flex w-100 justify-content-between",
                    "Line",
                    sparklineOutput("line", type = "line")
                  )
                ),
                values = c("bar", "dot", "line")
              )
            ),
            col(

            )
          )
        ),
        server = function(input, output) {
          gen10 <- function() {
            sample(10:100, 10, replace = TRUE) %/% 10 * 10
          }

          output$bar <- renderSparkline({
            gen10()
          })

          output$dot <- renderSparkline({
            gen10()
          })

          output$line <- renderSparkline({
            gen10()
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: sparkline.R
  source: "sparklineOutput <- function(id, type = \"bar\", labels = TRUE, \n    ...)
    {\n    if (!re(type, \"bar|dot|line\", FALSE)) {\n        stop(\"invalid `sparklineOutput`
    argument, `type` must be one of \", \n            \"\\\"bar\\\", \\\"dot\\\",
    or \\\"line\\\"\", call. = FALSE)\n    }\n    tags$span(class = collate(\"dull-sparkline-output\",
    paste0(\"spark-\", \n        type, \"-medium\")), id = id, `data-labels` = if
    (labels) \n        \"true\"\n    else \"false\", ...)\n}"
---
