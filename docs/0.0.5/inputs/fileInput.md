---
this: fileInput
filename: R/file.R
layout: page
roxygen:
  title: Upload user files
  description: Upload files to the server.
  parameters:
  - name: id
    description: A character string specifying the HTML id of the file input.
  - name: placeholder
    description: |-
      A character string specifying the text inside the file
      input, defaults to `"Choose file"`.
  - name: left,right
    description: |-
      A character string or button element placed prepended or
        appended respectively to the file input. For more information refer to
        [groupInput()](/yonder/0.0.5/groupInput().html).

        Clicking on an element specified by `right` also opens the file input
        dialog.
  - name: '...'
    description: |-
      Additional named arguments passed on as HTML attributes to the
      parent element.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifying whether or not the user
      can upload multiple files at once, defaults to `TRUE`.
  - name: accept
    description: |-
      A character vector of possible MIME types or file extensions,
      defaults to `NULL`, in which case any file type may be selected.
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
            fileInput("upload") %>%
              margin(0, "auto", 0, "auto")
          ),
          server = function(input, output) {
            observe({
              req(input$upload)
              print(input$upload)
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            fileInput(
              id = "upload",
              left = buttonInput(NULL, "Upload") %>%
                background("white") %>%
                border("green")
            ) %>%
              margin("auto", 0, "auto", 0)
          ),
          server = function(input, output) {
            observe({
              req(input$upload)
              for (path in input$upload$datapath) {
                cat(readLines(path), "\n")
              }
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            fileInput("upload1") %>%
              margin(3),
            fileInput("upload2") %>%
              margin(3)
          ),
          server = function(input, output) {
            observeEvent(input$upload1, {
              cat("Upload 1:", input$upload1$name, "\n")
            })
            observeEvent(input$upload2, {
              cat("Upload 2:", input$upload2$name, "\n")
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
