---
this: sparklineOutput
filename: R/sparkline.R
layout: page
roxygen:
  title: Sparkline output
  description: Display concise, reactive inline bar, line, or dot charts.
  parameters:
  - name: id
    description: A character string specifying the id of the sparkline output.
  - name: type
    description: |-
      One of `"bar"`, `"dot"`, or `"dotline"` specifying the type of
      chart to render, defaults to `"bar"`.
  - name: labels
    description: |-
      If `TRUE`, the first and last value of the sparkline data
      are used as labels, defaults to `TRUE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: expr
    description: |-
      An expression which returns a numeric vector specifying the
      values of the sparkline. These values will be scaled to 0 through 100.
  - name: env
    description: |-
      The environment in which to evaluate `expr`, defaults to the
      calling environment.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `expr` is a quoted
      expression.
  sections: ~
  return: ~
  family: outputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            sparklineOutput("bars")
          ),
          server = function(input, output) {
            output$bars <- renderSparkline({
              c(30, 20, 44, 50, 90)
            })
          }
        )
      }
    output: []
---
