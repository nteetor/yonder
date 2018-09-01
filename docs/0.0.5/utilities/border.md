---
this: border
filename: R/utilities.R
layout: page
roxygen:
  title: Tag element borders
  description: |-
    Use `border()` to add borders to a tag element or change the color of a tag
    element's border.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the border color, defaults to
      `NULL`, in which case the browser default is used. See below for possible
      border colors.
  - name: sides
    description: |-
      One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
      `"all"` or `"none"` specifying which sides to add a border to, defaults to
      `"all"`.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      h1("") %>%
        border("grey")
      div("Vivamus id enim.") %>%
        border("orange")
      if (interactive()) {
        colors <- c(
          "red", "purple", "indigo", "blue", "cyan", "teal", "green",
          "yellow", "amber", "orange", "grey", "white"
        )
        shinyApp(
          ui = container(
            center = TRUE,
            lapply(
              colors,
              border,
              .tag = div() %>%
                padding(5) %>%
                margin(2)
            )
          ) %>%
            display("flex") %>%
            flex(wrap = TRUE),
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
