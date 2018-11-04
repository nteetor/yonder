---
this: selectInput
filename: R/select.R
layout: page
requires: ~
roxygen:
  title: Select input
  description: |-
    Create a select input. Select elements often appear as a dropdown menu and
    may have one or more selected values, see `multiple`.
  parameters:
  - name: id
    description: A character string specifying the id of the select input.
  - name: choices
    description: |-
      A character vector specifying the labels of the select input
      options.
  - name: values
    description: |-
      A character vector specifying the values of the select input
      options, defaults to `chocies`.
  - name: selected
    description: |-
      One of `values` indicating the default value of the select
      input, defaults to `NULL`. If `NULL` the first value is selected by
      default.
  - name: multiple
    description: |-
      One of `TRUE` or `FALSE`, if `TRUE` multiple values may be
      selected, otherwise a single value is selected at a time,
      defaults to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Getting started</h3>
  - type: source
    value: |2-

      selectInput(
        id = NULL,
        choices = c(
          "Choose one",
          "Choice 1",
          "Choice 2",
          "Choice 3"
        ),
        values = list(NULL, 1, 2, 3)
      )
  - type: output
    value: |-
      <div class="yonder-select">
        <select class="custom-select">
          <option selected>Choose one</option>
          <option data-value="1">Choice 1</option>
          <option data-value="2">Choice 2</option>
          <option data-value="3">Choice 3</option>
        </select>
        <div class="invalid-feedback"></div>
      </div>
---
