---
this: sendModal
filename: R/modal.R
layout: page
roxygen:
  title: Modal dialogs
  description: |-
    Modals are a flexible alert window, which disable interaction with the page
    behind them. Modals may include inputs or buttons or simply include text.
  parameters:
  - name: title
    description: A character string specifying the modal's title.
  - name: body
    description: |-
      A character string specifying the body of the modal or
      custom element to use as the body of the modal, defaults to `NULL`.
  - name: footer
    description: |-
      Custom tags to include at the bottom of the modal, defaults to
      `NULL`.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain().html).
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            buttonInput(id = "button", "Click to show modal")
          ),
          server = function(input, output) {
            observeEvent(input$button, {
              sendModal(
                title = "A simple modal",
                body = paste(
                  "Cras mattis consectetur purus sit amet fermentum.",
                  "Cras justo odio, dapibus ac facilisis in, egestas",
                  "eget quam. Morbi leo risus, porta ac consectetur",
                  "ac, vestibulum at eros."
                )
              )
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              class = "justify-content-center",
              column(
                buttonInput(id = "trigger", "Trigger modal")
              )
            )
          ),
          server = function(input, output) {
            observeEvent(input$trigger, {
              sendModal(
                title = "Login",
                body = loginInput("login")
              )
            })
            observeEvent(input$login, {
              if (input$login$username != "" && input$login$password != "") {
                closeModal()
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
