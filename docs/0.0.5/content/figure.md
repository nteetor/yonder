---
this: figure
filename: R/tags.R
layout: page
roxygen:
  title: Responsive images and figures
  description: |-
    A small update to `tags$img` and `tags$figure`. Create responsive images with
    `img`. `figure` has specific arguments for an image child element and image
    caption.
  parameters:
  - name: src
    description: A character string specifying the source of the image.
  - name: image
    description: An `<img>` tag, typically a call to `img`.
  - name: caption
    description: |-
      A character string specifying the image caption, defaults to
      `NULL`.
  - name: '...'
    description: |-
      Additional tag elements or named arguments passed as HTML attributes
      to the parent element.
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
            img("https://upload.wikimedia.org/wikipedia/commons/1/18/Grey_Square.svg") %>%
              float("left") %>%
              rounded(),
            img("https://upload.wikimedia.org/wikipedia/commons/1/18/Grey_Square.svg") %>%
              float("right") %>%
              rounded()
          ),
          server = function(input, output) {
          }
        )
      }
      # Thank you to Wikimedia Commons
      # Grey square provided by Johannes Rössel (Own work) [Public domain]
      if (interactive()) {
        shinyApp(
          ui = container(
            figure(
              image = rounded(img("http://bit.ly/2qchbEB")),
              caption = "Stock cat photo."
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
