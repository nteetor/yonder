---
this: closeAlert
filename: R/alerts.R
layout: page
roxygen:
  title: Static and actionable alerts
  description: |-
    Use `showAlert` to let the user know of successes or to call attention to
    problems. While alerts are static by default they can also be made
    actionable. Actionable alerts can be used for undoing or redoing an action
    and more.
  parameters:
  - name: text
    description: A character string specifying the message text of the alert.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the
      alert element.
  - name: duration
    description: |-
      A positive integer or `NULL` specifying the duration of the
      alert, by default the alert is removed after 4 seconds. If `NULL` the
      alert is not automatically removed.
  - name: color
    description: |-
      A character string specifying the color of the alert,
      for possible colors see [background].
  - name: action
    description: |-
      A character string specifying a reactive id. If specified a
      button is added to the alert. If clicked the reactive value
      `input[[action]]` is set to `TRUE`. When the alert is removed
      `input[[action]]` is reset to `NULL`.
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
            buttonInput("show", "Alert!") %>%
              margin(3)
          ),
          server = function(input, output) {
            observeEvent(input$show, {
              color <- sample(c("teal", "red", "orange", "blue"), 1)
              showAlert("Alert", color = color)
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                groupInput(
                  id = "text",
                  right = buttonInput("clear", icon("times")) %>%
                    background("red")
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            ) %>%
              margin(3)
          ),
          server = function(input, output) {
            oldValue <- NULL
            output$value <- renderPrint(input$text)
            observeEvent(input$clear, {
              oldValue <<- input$text
              updateValues("text", "")
              showAlert("Undo clear.", color = "yellow", action = "undo")
            })
            observeEvent(input$undo, {
              updateValues("text", oldValue)
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
