---
this: background
filename: R/utilities.R
layout: page
roxygen:
  title: Tag element background color
  description: Use `background()` to change the background color of a tag element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the background color, see below
      for all possible values.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      div("Nullam eu ante vel est convallis dignissim.") %>%
        background("grey")
      checkbarInput(
        id = NULL,
        choices = c(
          "Nunc rutrum turpis sed pede.",
          "Etiam vel neque.",
          "Lorem ipsum dolor sit amet."
        )
      ) %>%
        background("cyan")
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
              background,
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
