---
this: checkboxInput
filename: R/checkbox.R
layout: page
roxygen:
  title: Checkbox inputs
  description: |-
    A reactive checkbox input. When a checkbox input is unchecked the reactive
    value is `NULL`. When checked the checkbox input reactive value is `value`.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the checkbox input, the
      reactive value of the checkbox input is available to the shiny server
      function as part of the `input` object.
  - name: choice
    description: A character string specifying a label for the checkbox.
  - name: value
    description: |-
      A character string, object to coerce to a character string, or
      `NULL` specifying the value of the checkbox or a new value for the
      checkbox, defaults to `choice`.
  - name: checked
    description: |-
      If `TRUE` the checkbox renders in a checked state, defaults
      to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      checkboxInput(
        id = "pellentesque",
        choice = "Cras placerat accumsan nulla"
      )
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                checkboxInput(
                  id = "checkbox",
                  choice = "Are you there?",
                  value = "yes"
                ),
                checkboxInput(
                  id = "hello",
                  choice = "Hello"
                )
              ),
              column(
                d4(
                  textOutput("value")
                )
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderText({
              input$checkbox
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            checkboxInput("foo", "Hello, world!", "hello"),
            textOutput("checkvalue", inline = TRUE),
            textInput("label", placeholder = "New checkbox text"),
            textInput("value", placeholder = "New checkbox value"),
            tags$div(
              buttonInput("choices", "Update checkbox text"),
              buttonInput("values", "Update checkbox value")
            ) %>%
              display("flex")
          ),
          server = function(input, output) {
            output$checkvalue <- renderPrint({
              if (is.null(input$foo)) {
                markInvalid("foo", "Please check")
              } else {
                markValid("foo")
              }
              input$foo
            })
            observeEvent(input$choices, {
              req(input$label)
              updateChoices("foo", hello = input$label)
            })
            observeEvent(input$values, {
              req(input$value, input$foo)
              updateValues("foo", !!(input$foo) := input$value)
            })
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
