---
this: formInput
filename: R/forms.R
layout: page
roxygen:
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
  return: ~
  family: inputs
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
                    margin(bottom = 2)
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderPrint({
              list(
                email = input$email, password = input$password,
                options = input$options, checked = input$checkbox
              )
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                h5("A form input"),
                p("Elements are non-reactive"),
                formInput(
                  id = "myform",
                  textInput(id = "text"),
                  rangeInput(id = "range")
                ) %>%
                  border("grey") %>%
                  padding(3) %>%
                  margin(bottom = 3),
                h5("This input is unaffected"),
                textInput(id = "standalone")
              ),
              column(
                h5("Form elements values:"),
                verbatimTextOutput("elements") %>%
                  padding(bottom = 3),
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
    output:
    - "function (req) \n{\n    if (!identical(req$REQUEST_METHOD, \"GET\")) \n        return(NULL)\n
      \   if (!isTRUE(grepl(uiPattern, req$PATH_INFO))) \n        return(NULL)\n    textConn
      <- file(open = \"w+\")\n    on.exit(close(textConn))\n    showcaseMode <- .globals$showcaseDefault\n
      \   if (.globals$showcaseOverride) {\n        mode <- showcaseModeOfReq(req)\n
      \       if (!is.null(mode)) \n            showcaseMode <- mode\n    }\n    testMode
      <- .globals$testMode %OR% FALSE\n    bookmarkStore <- getShinyOption(\"bookmarkStore\",
      default = \"disable\")\n    if (bookmarkStore == \"disable\") {\n        restoreContext
      <- RestoreContext$new()\n    }\n    else {\n        restoreContext <- RestoreContext$new(req$QUERY_STRING)\n
      \   }\n    withRestoreContext(restoreContext, {\n        uiValue <- NULL\n        if
      (is.function(ui)) {\n            if (length(formals(ui)) > 0) {\n                uiValue
      <- ..stacktraceon..(ui(req))\n            }\n            else {\n                uiValue
      <- ..stacktraceon..(ui())\n            }\n        }\n        else {\n            if
      (getCurrentRestoreContext()$active) {\n                warning(\"Trying to restore
      saved app state, but UI code must be a function for this to work! See ?enableBookmarking\")\n
      \           }\n            uiValue <- ui\n        }\n    })\n    if (is.null(uiValue))
      \n        return(NULL)\n    renderPage(uiValue, textConn, showcaseMode, testMode)\n
      \   html <- paste(readLines(textConn, encoding = \"UTF-8\"), collapse = \"\\n\")\n
      \   return(httpResponse(200, content = enc2utf8(html)))\n}"
    - "function () \n{\n    server\n}"
    - 'NULL'
    - list()
    - list(appDir = "/Users/nteetor/git/zeppelin", bookmarkStore = NULL)
---
