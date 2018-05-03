---
layout: page
slug: table-thruput
roxygen:
  rdname: ~
  name: tableThruput
  doctype: ~
  title: Table thruput
  description: Render a table. Thruputs are a new reactive object.
  parameters:
  - name: id
    description: A character string specifying the id of the table thruput.
  - name: borders
    description: |-
      If `TRUE`, the table renders with cell borders, defaults to
      `FALSE`.
  - name: compact
    description: |-
      If `TRUE`, table cell padding is cut in half to reduce the
      size of the table, defaults to `FALSE`.
  - name: expr
    description: |-
      An expression which returns a data frame or `NULL`. If a data
      frame is returned the table thruput is re-rendered, otherwise if `NULL` the
      current table thruput is left as is.
  - name: quoted
    description: |-
      If `TRUE`, then `expr` is treated as a quoted expression,
      defaults to `FALSE`.
  - name: session
    description: |-
      A `session` object passed to the shiny server function,
      defaults to [`getDefaultReactiveDomain()`].
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              tableThruput(
                id = "table"
              )
            ),
            col(
              verbatimTextOutput("value")
            )
          )
        ),
        server = function(input, output) {
          output$table <- renderTable({
            iris[1:10, ]
          })

          output$value <- renderPrint({
            input$table
          })
        }
      )
    }

    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            col(
              tableThruput(
                id = "table",
                borders = TRUE
              )
            ),
            col(
              tableThruput(
                id = "subset",
                borders = TRUE
              )
            )
          )
        ),
        server = function(input, output) {
          output$table <- renderTable({
            mtcars[1:10, ]
          })

          output$subset <- renderTable({
            input$table
          })
        }
      )
    }
  aliases: ~
  family: ~
  export: yes
  filename: table.R
  source:
  - tableThruput <- function(id, borders = FALSE, context = NULL,
  - '                         compact = FALSE, ...) {'
  - '  if (!is.null(id) && !is.character(id)) {'
  - '    stop('
  - '      "invalid `tableThruput` argument, `id` must be a character string or ",'
  - '      "NULL", call. = FALSE'
  - '    )'
  - '  }'
  - '  shiny::registerInputHandler(type = "dull.table.input", fun = function(x,'
  - '                                                                        session,
    name) {'
  - '    frame <- jsonlite::fromJSON(x)'
  - '    if (NROW(frame) == 0 || NCOL(frame) == 0) {'
  - '      return(NULL)'
  - '    }'
  - '    frame'
  - '  }, force = TRUE)'
  - '  tags$table(class = collate('
  - '    "dull-table-thruput", "table",'
  - '    if (is.character(id)) {'
  - '      "table-hover"'
  - '    } , "table-responsive", if (borders) {'
  - '      "table-bordered"'
  - '    } , if (compact) {'
  - '      "table-sm"'
  - '    }'
  - '  ), id = id, ...)'
  - '}'
---
