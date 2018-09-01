---
this: sendBar
filename: R/progress.R
layout: page
roxygen:
  title: Progress bars
  description: |-
    Create simple or composite progress bars. To create a composite progress bar
    pass multiple calls to `bar` to a progress output. Each `bar` component has
    its own id, value, label, and attributes. Furthermore, utility functions may
    be applied to individual bars for added customization.
  parameters:
  - name: id
    description: A character string specifying the HTML id of a progress output.
  - name: '...'
    description: |-
      One or more `bar` elements passed to a progress output or named
      arguments passed as HTML attributes to the parent element.
  - name: value
    description: |-
      An integer between 0 and 100 specifying the initial value
      of a bar.
  - name: label
    description: |-
      A character string specifying the label of a bar, defaults to
      `NULL`, in which case a label is not added.
  - name: striped
    description: |-
      If `TRUE`, the progress bar has a striped gradient, defaults
      to `FALSE`.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()].
  sections: ~
  return: ~
  family: outputs
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
                buttonInput(id = "inc", "Increment progress")
              ),
              column(
                progressOutput(
                  bar("clicks", 0, striped = TRUE) %>%
                    background("blue")
                )
              )
            )
          ),
          server = function(input, output) {
            observeEvent(input$inc, {
              sendBar(
                id = "clicks",
                value = min(input$inc / 20 * 100, 100)
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
                progressOutput(
                  bar(id = "faster", value = 0) %>%
                    background("yellow"),
                  bar(id = "slower", value = 0)
                )
              )
            )
          ),
          server = function(input, output) {
            observe({
              for (i in seq(from = 0, to = 50, by = 1)) {
                sendBar(
                  id = "slower",
                  value = i
                )
                sendBar(
                  id = "faster",
                  value = min(i * 3, 50)
                )
                Sys.sleep(0.1)
              }
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
