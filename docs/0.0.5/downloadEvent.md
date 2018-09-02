---
this: downloadEvent
filename: R/download.R
layout: page
roxygen:
  title: Trigger a download
  description: |-
    An alternative to `downloadLink` and `downloadHelper`. `downloadEvent` allows
    a custom reactive event to trigger a download. Thus, a single handler may be
    used for a complex reactive input or widget.
  parameters:
  - name: event
    description: |-
      A reactive input value (e.g. `input$click`), a call to a
      reactive expression, or a new expression inside curly braces. When `event`
      is triggered the file download is triggered.
  - name: filename
    description: |-
      A reactive input value, a call to a reactive expression, a
      function, or a new expression inside curly braces which returns a string
      specifying the name of the downloaded file.
  - name: handler
    description: |-
      A **function** with one argument that is expected to write the
      content of the downloaded file. A temporary file is passed to the function,
      which is expected to write content (text, images, etc.) to the temporary
      file.
  - name: domain
    description: |-
      A shiny session object, defaults to
      [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain().html).
  sections: ~
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            textInput("name", "File name"),
            buttonInput("trigger", "Download")
          ),
          server = function(input, output) {
            downloadEvent(input$trigger, {
              if (is.null(input$name)) {
                "default"
              } else {
                input$name
              }
            }, function(file) {
              cat("hello, world!", file = file)
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
