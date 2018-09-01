---
this: shadow
filename: R/utilities.R
layout: page
roxygen:
  title: Add shadows to tag elements
  description: |-
    The `shadow` utility applies a shadow to a tag element. Elements with a
    shadow may appear to pop off the page. The material design set of components,
    used on Android and for Google applications, commonly uses shadowing.
    Although `"none"` is an allowed `size`, most elements do not have a shadow by
    default.
  parameters:
  - name: .tag
    description: A tag element.
  - name: size
    description: |-
      One of `"none"`, `"small"`, `"regular"`, or `"large"` specifying
      the amount of shadow added, defaults to `"regular"`.
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
          ui = tagList(
            navbar(brand = "Navbar") %>%
              background("cyan") %>%
              shadow("small"),
            container(
              "Cras mattis consectetur purus sit amet fermentum. Donec sed ",
              "odio dui. Lorem ipsum dolor sit amet, consectetur adipiscing ",
              "elit. Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
              "venenatis vestibulum."
            ) %>%
              padding(3)
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
