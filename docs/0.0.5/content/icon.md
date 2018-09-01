---
this: icon
filename: R/icons.R
layout: page
roxygen:
  title: Icon elements
  description: |-
    Include an icon in your application. For now only Font Awesome icons are
    included.
  parameters:
  - name: name
    description: A character string specifying the name of the icon.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: set
    description: |-
      A character string specifying the icon set to choose from, defaults
      to `"NULL"`, in which case all icon sets are searched.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = container(
            center = TRUE,
            selectInput(
              id = "name",
              choices = unique(icons$name)
            ) %>%
              margin(3),
            div(
              htmlOutput("icon")
            ) %>%
              margin(3) %>%
              display("flex") %>%
              flex(direction = "column", align = "center")
          ),
          server = function(input, output) {
            output$icon <- renderUI({
              icon(input$name) %>%
                font(size = "8x")
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            lapply(
              unique(icons$set),
              function(s) {
                div(
                  lapply(
                    unique(icons[icons$set == s, ]$name),
                    function(nm) {
                      icon(nm, set = s) %>%
                        margin(2)
                    }
                  )
                ) %>%
                  display("flex") %>%
                  flex(wrap = TRUE)
              }
            )
          ),
          server = function(input, output) {
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
