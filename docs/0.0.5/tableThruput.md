---
this: tableThruput
filename: R/table.R
layout: page
roxygen:
  title: Table thruput
  description: |-
    Use `tableThruput()` to create a table output you can update with
    `renderTable()`. Access selected table columns by referencing the same
    table id as an input.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the table thruput. This id
      is used as both an input and output reactive.
  - name: borders
    description: |-
      One of `"rows"`, `"all"`, or `"none"` specifying what borders
      are applied to the table, defaults to `"rows"`. `"rows"` will apply borders
      between table rows. `"all"` will apply borders between table rows and
      columns. `"none"` removes all borders from the table.
  - name: striped
    description: |-
      One `TRUE` or `FALSE` specifying if the table rows alternate
      between light and darker backgrounds.
  - name: compact
    description: |-
      One of `TRUE` or `FALSE` specifying if the table cells are
      rendered with less space, defaults to `FALSE`.
  - name: responsive
    description: |-
      One of `TRUE` or `FALSE` specifying if the table is allowed
      to scroll horizontally, default to `FALSE`. This is useful when fitting
      wide tables onto small viewports.
  - name: editable
    description: |-
      One of `TRUE` or `FALSE` specifying if the user can edit
      table cells, defaults to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: expr
    description: |-
      An expression which returns a data frame or `NULL`. If a data
      frame is returned the table thruput is re-rendered, otherwise if `NULL` the
      current table is left as is.
  - name: env
    description: |-
      The environment in which to evaluate `expr`, defaults to
      `parent.frame()`.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `expr` is a quoted
      expression.
  sections: ~
  return: ~
  family: ~
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
                width = 6,
                tableThruput(
                  id = "table1",
                  responsive = TRUE,
                  editable = TRUE
                )
              ),
              column(
                width = 6,
                verbatimTextOutput("value")
              )
            )
          ),
          server = function(input, output) {
            observeEvent(input$table1, once = TRUE, {
              showAlert("Click a table cell to edit the value!", color = "amber")
            })
            output$table1 <- renderTable({
              iris
            })
            output$value <- renderPrint({
              input$table1
            })
          }
        )
      }
      if (interactive()) {
        shinyApp(
          ui = container(
            row(
              column(
                tableThruput(
                  id = "table1",
                  borders = "all",
                  responsive = TRUE
                )
              ),
              column(
                tableThruput(
                  id = "table2",
                  borders = "all",
                  responsive = TRUE
                )
              )
            )
          ),
          server = function(input, output) {
            output$table1 <- renderTable({
              mtcars[1:10, ]
            })
            output$table2 <- renderTable({
              input$table1
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
