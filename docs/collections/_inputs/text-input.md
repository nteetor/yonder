---
layout: page
slug: text-input
roxygen:
  rdname: ~
  name: textInput
  doctype: ~
  title: Textual inputs
  description: Textual inputs.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the textual input, defaults
      to `NULL`.
  - name: value
    description: |-
      A character string or a value coerced to a character string
      specifying the default value of the textual input.
  - name: placeholder
    description: |-
      A character string specifying placeholder text for the
      input, defaults to `NULL`, in which case there is no placeholder text.
  - name: size
    description: |-
      One of `"small"` or `"large"` specifying the size transformation
      of the input, defaults to `NULL`, in which case the input's size is
      unchanged.
  - name: readonly
    description: |-
      If `TRUE`, the textual input is read-only preventing
      modification of the value, defaults `FALSE`.
  - name: help
    description: |-
      A character string specifying the help text of the textual input,
      defaults to `NULL`, in which case no help text is added.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  examples: |+
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              p("For best results open in a browser") %>%
                font(weight = "bold")
            )
          ),
          row(
            col(
              h6("Text input:"),
              textInput(id = "text"),
              h6("Search input:"),
              searchInput(id = "search"),
              h6("Email input:"),
              emailInput(id = "email"),
              h6("URL input:"),
              urlInput(id = "url"),
              h6("Telephone input:"),
              telephoneInput(id = "tel"),
              h6("Password input:"),
              passwordInput(id = "pass"),
              h6("Number input:"),
              numberInput(id = "num") %>%
                background("lime", +1)
            ),
            col(
              verbatimTextOutput("values")
            )
          )
        ),
        server = function(input, output) {
          output$values <- renderPrint({
            list(
              text = input$text, search = input$search, email = input$email,
              url = input$url, telephone = input$tel, password = input$pass,
              number = input$num
             )
          })
        }
      )
    }

  aliases: ~
  family: inputs
  export: yes
  filename: textual.R
  source: "textInput <- function(id, value = NULL, placeholder = NULL, size = NULL,
    \n    readonly = FALSE, help = NULL, ...) {\n    textualInput(id, value, placeholder,
    readonly, help, \"text\", \n        size = size, ...)\n}"
redirect_from: /docs/0.0.5/inputs/
---
