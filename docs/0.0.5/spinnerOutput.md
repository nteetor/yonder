---
this: spinnerOutput
filename: R/icons.R
layout: page
roxygen:
  title: A spinner
  description: Start or stop a spinner based on process progress.
  parameters:
  - name: id
    description: A character specifying the id of the spinner output.
  - name: type
    description: |-
      One of `"circle"`, `"cog"`, `"dots"`, or `"sync"` specifying the
      type of spinner, defaults to `"circle"`.
  - name: pulse
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` the spinner rotates in 8
      discrete steps, defaults to `FALSE`.
  - name: '...'
    description: |-
      Additional named argument passed as HTML attributes to the
      parent element.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain())].
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
            row(
              column(
                spinnerOutput("spin", pulse = TRUE),
                buttonInput("trigger", "Start/stop")
              ) %>%
                display("flex") %>%
                flex(justify = "around")
            )
          ),
          server = function(input, output) {
            observeEvent(input$trigger, {
              if (input$trigger %% 2 == 1) {
                startSpinner("spin")
              } else {
                stopSpinner("spin")
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
