---
this: buttonGroupInput
filename: R/button.R
layout: page
roxygen:
  title: Button group inputs
  description: Groups of buttons with a persisting value.
  parameters:
  - name: id
    description: A character string specifying the id of the button group input.
  - name: labels
    description: |-
      A character vector of labels, a button is added to the group
      for each label specified.
  - name: values
    description: |-
      A character vector of values, one for each button specified,
      defaults to `labels`.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      buttonGroupInput("group", c("Once", "Twice"), c(1, 2))
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                buttonGroupInput(
                  id = "group",
                  labels = c("Once", "Twice", "Thrice"),
                  values = c(1, 2, 3)
                )
              ),
              column(
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            output$value <- renderPrint({
              input$group
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                buttonGroupInput(
                  id = "bg1",
                  labels = c("Button 1", "Button 2", "Button 3")
                ) %>%
                  background("blue") %>%
                  margin(3)
              ),
              column(
                buttonGroupInput(
                  id = "bg2",
                  labels = c("Groupee 1", "Groupee 2", "Groupee 3")
                ) %>%
                  background("yellow") %>%
                  margin(3)
              )
            )
          ),
          server = function(input, output) {
            observe({
              print(input$bg1)
            })
            observe({
              print(input$bg2)
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
