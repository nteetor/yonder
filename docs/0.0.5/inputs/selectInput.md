---
this: selectInput
filename: R/select.R
layout: page
roxygen:
  title: Select input
  description: |-
    Create a select input. Select elements often appear as a dropdown menu and
    may have one or more selected values, see `multiple`.
  parameters:
  - name: id
    description: A character string specifying the id of the select input.
  - name: choices
    description: |-
      A character vector specifying the labels of the select input
      options.
  - name: values
    description: |-
      A character vector specifying the values of the select input
      options, defaults to `chocies`.
  - name: selected
    description: |-
      One of `values` indicating the default value of the select
      input, defaults to `NULL`. If `NULL` the first value is selected by
      default.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` multiple values may be
      selected, otherwise a single value is selected at a time,
      defaults to `FALSE`.
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
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                selectInput(
                  id = "select",
                  choices = c("Choose one", "One", "Two", "Three"),
                  values = list(NULL, 1, 2, 3),
                  multiple = TRUE
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
              input$select
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
