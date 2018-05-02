---
layout: page
slug: form-input
roxygen:
  rdname: ~
  name: formInput
  doctype: ~
  title: Form inputs
  description: |-
    Form inputs are a new reactive input. Form inputs are an alternative to
    shiny's submit buttons. A form input is comprised of any number of
    inputs. The value of these inputs will not change until the form input's
    submit button is clicked. A form input has no value.

    **Important** if `id` or `submit` are `NULL` the form input will not freeze
    its child inputs. This can be useful if you want to use a `formInput()`
    solely for page layout.
  parameters:
  - name: id
    description: A character string specifying an id for the form input.
  - name: '...'
    description: |-
      Any number of inputs, tags, or additional named arguments passed
      as HTML attributes to the parent element.
  - name: submit
    description: |-
      A submit button or tags containing a submit button. The submit
      button will trigger the update of input form elements. Defaults to
      [submitInput()].
  - name: inline
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` the form and its child
      elements are rendered in a horizontal row, defaults to `FALSE`. On small
      viewports, think mobile device, `inline` has no effect and the form will
      span multiple lines.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              formInput(
                id = "form",
                tags$label("Email"),
                emailInput(
                  id = "email",
                  placeholder = "Email"
                ),
                tags$label("Password"),
                passwordInput(
                  id = "password",
                  placeholder = "Password"
                ),
                tags$label("Radio"),
                radioInput(
                  id = "options",
                  choices = c(
                    "Option one",
                    "Option two",
                    "Option three"
                  )
                ),
                tags$label("Checkbox"),
                checkboxInput(
                  id = "checkbox",
                  choice = "Simple checkbox"
                ) %>%
                  margins(c(0, 0, 2, 0))
              )
            ),
            col(
              verbatimTextOutput("value")
            )
          )
        ),
        server = function(input, output) {
          output$value <- renderPrint({
            str(input$form)
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              h5("A form input"),
              p("Elements are non-reactive"),
              formInput(
                id = "myform",
                textInput(id = "text"),
                rangeInput(id = "range")
              ) %>%
                border("grey", -1) %>%
                padding(3) %>%
                margins(c(0, 0, 3, 0)),
              h5("This input is unaffected"),
              textInput(id = "standalone")
            ),
            col(
              h5("Form elements values:"),
              verbatimTextOutput("elements") %>%
                padding(c(0, 0, 3, 0)),
              h5("Unaffected text input value:"),
              textOutput("unaffected")
            )
          )
        ),
        server = function(input, output) {
          output$elements <- renderPrint(list(
            text = input$text,
            range = input$range
          ))

          output$unaffected <- renderPrint(input$standalone)
        }
      )
    }
  aliases: ~
  family: inputs
  export: yes
  filename: forms.R
  source: "formInput <- function(id, ..., submit = submitInput(), inline = FALSE)
    {\n    tags$form(class = collate(\"dull-form-input\", if (inline) \n        \"form-inline\"),
    id = id, ..., submit, include(\"core\"))\n}"
---
