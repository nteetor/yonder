---
this: loginInput
filename: R/textual.R
layout: page
roxygen:
  title: Login input
  description: A composite input which consists of a username field and a password
    field.
  parameters:
  - name: id
    description: A character string specifying the HTML id of the login input.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attibutes to the login
      input.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: source
    value: |2-

      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                loginInput(
                  id = "login"
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderPrint({
              input$login
            })

          }
        )
      }
  - type: code
    value: |-
      if (interactive()) {
          shinyApp(ui = container(row(column(loginInput(id = "login")), column(verbatimTextOutput("value")))), server = function(input, output) {
              output$value <- renderPrint({
                  input$login
              })
          })
      }
---
