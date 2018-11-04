---
this: renderTable
filename: R/table.R
layout: page
requires: data
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
  sections: []
  return: ~
  family: thruputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Responsive tables</h3>
  - type: markdown
    value: |
      <p>In practice you will use <code>renderTable()</code> to update the data in a table. These live examples have been populated automatically for the sake of the demo.</p>
  - type: source
    value: |2-

      tableThruput(
        id = "table1",  # <-
        responsive = TRUE
      )
  - type: output
    value: <table class="yonder-table table" id="table1" data-responsive="true" data-editable="false"></table>
  - type: markdown
    value: |
      <h3>Borders on rows and columns</h3>
  - type: source
    value: |2-

      tableThruput(
        id = "table2",
        borders = "all",  # <-
        responsive = TRUE
      )
  - type: output
    value: <table class="yonder-table table table-bordered" id="table2" data-responsive="true"
      data-editable="false"></table>
  - type: markdown
    value: |
      <h3>Edit table values</h3>
  - type: source
    value: |2-

      tableThruput(
        id = "table3",
        editable = TRUE,  # <-
        responsive = TRUE
      )
  - type: output
    value: <table class="yonder-table table" id="table3" data-responsive="true" data-editable="true"></table>
---
