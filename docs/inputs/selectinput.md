---
name: selectInput
title: Select input
description: |-
  Create a select input. Select elements often appear as a dropdown menu and
  may have one or more selected values, see `multiple`.
inheritParams: buttonInput
parameters:
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
    selected, otherwise a single value is selected at a time, defaults to
    `FALSE`.
family: inputs
export: ''
examples:
- title: Getting started
  body:
  - type: code
    content: |-
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
    output: |-
      <div class="yonder-select">
        <select class="custom-select">
          <option>Choose one</option>
          <option value="1">Choice 1</option>
          <option value="2">Choice 2</option>
          <option value="3">Choice 3</option>
        </select>
        <div class="invalid-feedback"></div>
      </div>
rdname: selectInput
sections: []
layout: doc
---
