---
this: navbar
filename: R/navbar.R
layout: page
roxygen:
  title: Page and content navigation
  description: |-
    Add a navigation bar to your application with `navbar()`. Navigation bars may
    include a tab toggle (useful for multi-page applications), inline forms
    (perhaps a search feature or login item), or character strings to add simple
    text. Navbars are responsive and will collapse on small screens, think mobile
    device. A button is automatically added to toggle between the collapsed and
    expanded states.
  parameters:
  - name: '...'
    description: |-
      A tab toggle, inline forms, or text to add to include as part of
      the navigation bar.
  - name: brand
    description: |-
      A tag element or text placed on the left end of the navbar,
      defaults to `NULL`, in which case nothing is added.
  sections: ~
  return: ~
  family: layout
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      if (interactive()) {
        shinyApp(
          ui = tagList(
            navbar(
              brand = "Navbar",
              tabTabs("myTabs", c("Home", "About", "Our process")) %>%
                margin(right = "auto"),
              formInput(
                inline = TRUE,
                id = "navForm",
                searchInput("search", placeholder = "Search") %>%
                  margin(right = c(sm = 2)),
                submit = submitInput("Search") %>%
                  background("amber")
              )
            ) %>%
              background("teal"),
            container(
              tabContent(
                tabs = "myTabs",
                tabPane(
                  h3("Home")
                ),
                tabPane(
                  h3("About")
                ),
                tabPane(
                  h3("The process")
                )
              )
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
