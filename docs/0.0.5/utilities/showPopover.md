---
this: showPopover
filename: R/popover.R
layout: page
roxygen:
  title: Display a popover
  description: |-
    Popovers are small windows of content associated with a tag element. Use
    `showPopover()` to add a popover to any tag element with an HTML id. This
    allows you to add explanations for inputs. Furthermore the [linkInput()](/yonder/0.0.5/linkInput().html)
    makes adding popovers to semi-plain text possible. Popovers are hidden with
    `closePopover()`.
  parameters:
  - name: id
    description: |-
      A character string specifying the HTML id of a popover's target tag
      element.
  - name: content
    description: |-
      A character string or tag element specifying the content of
      the popover.
  - name: title
    description: |-
      A character string specifying a title for the popover, defaults
      to `NULL`, in which case a title is not added.
  - name: placement
    description: |-
      One of `"top"`, `"left"`, `"bottom"`, or `"right"`
      specifying where the popover is positioned relative to the target tag
      element indicated by `id`.
  - name: duration
    description: |-
      A positive integer specifying the duration of the popover
      in seconds or `NULL`, in which case the popover is not automatically
      removed. When `NULL` is specified the popover can be removed with
      `closePopover()`.
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
            buttonInput("click", "Button"),
            buttonInput("close", icon("times")) %>%
              background("red")
          ),
          server = function(input, output) {
            observeEvent(input$click, {
              showPopover(
                id = "click",
                text = "This is a button!",
                placement = "bottom",
                duration = NULL
              )
            })
            observeEvent(input$close, {
              closePopover("click")
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
