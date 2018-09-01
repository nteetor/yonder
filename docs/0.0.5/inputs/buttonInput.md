---
this: buttonInput
filename: R/button.R
layout: page
roxygen:
  title: Button and submit inputs
  description: |-
    Button inputs are useful as triggers for reactive or observer expressions.
    The reactive value of a button input is the number of times it has been
    clicked.

    A submit input is a special type of button used to control HTML form
    submission. Unlike shiny's `submitButton`, `submitInput` will not freeze all
    reactive inputs on the page.
  parameters:
  - name: id
    description: A character string specifying the id of the button or link input.
  - name: label
    description: |-
      A character string specifying the label text on the button
      input.
  - name: block
    description: |-
      If `TRUE`, the input is block-level instead of inline, defaults
      to `FALSE`. A block-level element will occupy the entire width of its
      parent element.
  - name: text
    description: |-
      A character string specifying the text displayed as part of the
      link input.
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
                buttonInput(
                  id = "button",
                  label = "Click me!"
                ) %>%
                  background("green")
              ),
              column(
                d4(
                  textOutput("clicks")
                )
              )
            )
          ),
          server = function(input, output) {
            output$clicks <- renderText({
              input$button
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            center = TRUE,
            buttonInput(
              id = "button",
              label = list(
                "Increment badge",
                badgeOutput(
                  id = "badge"
                ) %>%
                  background("green")
              )
            ) %>%
              background("amber")
          ),
          server = function(input, output) {
            output$badge <- renderBadge({
              input$button
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
