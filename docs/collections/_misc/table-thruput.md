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
      One of `TRUE` or `FALSE` specifying if the table renders with
      cell borders, defaults to `FALSE`.
  - name: compact
    description: |-
      One of `TRUE` or `FALSE` specifying if the table cells are
      rendered with less space, defaults to `FALSE`.
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
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          row(
            column(
              tableThruput(
                id = "table"
              )
            ),
            column(
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
            column(
              tableThruput(
                id = "table",
                borders = TRUE
              )
            ),
            column(
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
  source: "tableThruput <- function(id, borders = FALSE, compact = FALSE, \n    ...)
    {\n    if (!is.null(id) && !is.character(id)) {\n        stop(\"invalid `tableThruput`
    argument, `id` must be a character string or \", \n            \"NULL\", call.
    = FALSE)\n    }\n    shiny::registerInputHandler(type = \"dull.table.input\",
    fun = function(x, \n        session, name) {\n        frame <- jsonlite::fromJSON(x)\n
    \       if (NROW(frame) == 0 || NCOL(frame) == 0) {\n            return(NULL)\n
    \       }\n        frame\n    }, force = TRUE)\n    tags$table(class = collate(\"dull-table-thruput\",
    \"table\", \n        if (is.character(id)) \n            \"table-hover\", \"table-responsive\",
    if (borders) \n            \"table-bordered\", if (compact) \n            \"table-sm\"),
    id = id, ...)\n}"
---
