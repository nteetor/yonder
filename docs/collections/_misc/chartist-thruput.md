---
layout: page
slug: chartist-thruput
roxygen:
  rdname: ~
  name: chartistThruput
  doctype: ~
  title: A chartist thruput
  description: '**Under development**. A reactive chart control.'
  parameters:
  - name: id
    description: A character string specifying the id of the thruput control.
  sections: ~
  examples: |
    shinyApp(
      ui = container(
        row(
          col(
            chartistThruput("test")
          )
        )
      ),
      server = function(input, output) {

      }
    )
  aliases: ~
  family: ~
  export: no
  filename: chartist.R
  source: |-
    chartistThruput <- function(id) {
        NULL
    }
---
