---
this: dateRangeInput
filename: R/datetime.R
layout: page
roxygen:
  title: Date time input
  description: |-
    A date time picker. Alternatively, use the date time range picker to select
    a range of dates. The value of the date range picker is always two dates.
  parameters:
  - name: id
    description: A character specifying the id of the datetime input.
  - name: choices
    description: |-
      Date objects or character strings specifying the set of
      dates the user may choose from, defaults to `NULL` in which case the user
      may choose any date.
  - name: selected
    description: |-
      Date objects or character strings specifying the dates
      selected by default in the date input, defaults `NULL` in which case no
      dates are selected by default.
  - name: min,max
    description: |-
      Date objects or character strings in the format `YYYY-mm-dd`
      specifying the minimum and maximum date that can be selecetd, both
      default to `NULL` in which case there is no minimum or maximum value
      respectively.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE` specifying whether multiple dates
      may be selected, if `TRUE` the user may select multiple dates and a vector
      of one or more dates is returned as the reactive value.
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
                h6("Single date input:"),
                dateInput(
                  id = "singledate"
                ),
                h6("Multiple dates input:") %>%
                  margin(3, 0, 2, 0),
                dateInput(
                  id = "multdate",
                  choices = Sys.Date() + (-4:4),
                  selected = Sys.Date() + 1,
                  multiple = TRUE
                )
              ),
              column(
                verbatimTextOutput("values")
              )
            )
          ),
          server = function(input, output) {
            output$values <- renderPrint({
              list(
                single = input$singledate,
                multiple = input$multdate
              )
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
