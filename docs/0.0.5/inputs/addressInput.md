---
this: addressInput
filename: R/textual.R
layout: page
roxygen:
  title: Address input
  description: |-
    A composite input which includes a street field, apartment or unit field,
    city field, state field, and a zip code field.
  parameters:
  - name: id
    description: A character string specifying the id of the address input.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      top-level element.
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
                tags$form(
                  addressInput("address")
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderPrint({
              input$address
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
