---
this: font
filename: R/utilities.R
layout: page
roxygen:
  title: Tag element font
  description: |-
    The `font()` utility may be used to change the color, size, or weight of a
    tag element's text font. Font size's are changed relative to the base font
    size of the web page.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the text color of the tag element,
      defaults to `NULL` in which case the text color is unchanged.
  - name: size
    description: |-
      One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
      increase a tag element's font size by (e.g. `"2x"` is double the base font
      size), defaults to `NULL`, in which case the font size is unchanged.
  - name: weight
    description: |-
      One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
      `"monospace"` specifying the font weight of the element's text, defaults to
      `NULL`, in which case the font weight is unchanged.
  - name: align
    description: |-
      A [responsive] argument. One of `"left"`, `"center"`, `"right"`,
      or `"justify"`.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      span("This and other news") %>%
        font(weight = "light")
      icon("anchor") %>%
        font(color = "blue", size = "5x")
      p("Ipsum Consectetur Nibh Bibendum Ullamcorper") %>%
        font(size = "2x", weight = "italic")
      if (interactive()) {
        colors <- c(
          "red", "purple", "indigo", "blue", "cyan", "teal", "green",
          "yellow", "amber", "orange", "body", "grey", "white"
        )
        shinyApp(
          ui = container(
            center = TRUE,
            lapply(
              head(colors, -1),
              font,
              .tag = div("Pellentesque tristique imperdiet tortor.") %>%
                padding(5)
            ),
            div("Pellentesque tristique imperdiet tortor.") %>%
              padding(5) %>%
              background("grey") %>%
              font(tail(colors, 1))
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
