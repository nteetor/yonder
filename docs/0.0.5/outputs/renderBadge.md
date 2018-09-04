---
this: renderBadge
filename: R/badge.R
layout: page
roxygen:
  title: Badge outputs
  description: |-
    Small highlighted content which scales to its parent's size. Useful for
    displaying dynamically changing counts or tickers, drawing attention to new
    options, or tagging content.
  parameters:
  - name: id
    description: A character string specifying the id of the badge output.
  - name: '...'
    description: |-
      Additional named argument passed as HTML attributes to the parent
      element.
  - name: expr
    description: |-
      An expression which returns a character string specifying the
      label of the badge.
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
            row(
              column(
                buttonInput(
                  id = "mybutton",
                  label = list(
                    "Number of clicks: ",
                    badgeOutput("clicks") %>%
                      background("red")
                  )
                )
              )
            )
          ),
          server = function(input, output) {
            output$clicks <- renderBadge({
              input$mybutton
            })
          }
        )
      }
    output: []
---
