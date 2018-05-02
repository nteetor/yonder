---
layout: page
slug: login-input
roxygen:
  rdname: ~
  name: loginInput
  doctype: ~
  title: Login input
  description: A complex input which consists of a username field and a password field.
  parameters:
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attibutes to the login
      input.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              loginInput(
                id = "login"
              )
            ),
            col(
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
  aliases: ~
  family: ~
  export: yes
  filename: textual.R
  source: "loginInput <- function(id, ...) {\n    ids <- ID(rep.int(\"login\", 2))\n
    \   tags$div(class = \"dull-login-input col\", id = id, tags$div(class = \"form-group\",
    \n        tags$label(class = \"form-control-label\", `for` = ids[[1]], \n            \"Username\"),
    tags$input(id = ids[[1]], type = \"text\", \n            class = \"form-control\")),
    tags$div(class = \"form-group\", \n        tags$label(class = \"form-control-label\",
    `for` = ids[[2]], \n            \"Password\"), tags$input(id = ids[[1]], type
    = \"password\", \n            class = \"form-control\")), tags$button(class =
    \"btn btn-primary\", \n        \"Login\"), ...)\n}"
---
