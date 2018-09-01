---
this: tooltip
filename: R/tooltip.R
layout: page
roxygen:
  title: Tooltips
  description: |-
    Add a tooltip to a tag element. Tooltips may be placed above, below, left, or right of
    an element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: text
    description: The tooltip text.
  - name: placement
    description: |-
      One of `"top"`, `"right"`, `"bottom"`, or `"left"`
      specifying what side of the tag element the tooltip appears on.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      div(
        "The island of ",
        span("Yll") %>%
          tooltip("An island of south of the Commonwealth")
      )
      if (interactive()) {
        shinyApp(
          ui = container(
            checkboxInput("add", "Add more") %>%
              display("inline-block") %>%
              tooltip("How to know")
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
