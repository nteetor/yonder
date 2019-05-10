---
name: updateButtonGroupInput
title: Button group inputs
description: A set of buttons with custom values.
inheritParams: buttonInput
parameters:
- name: labels
  description: |-
    A character vector specifying the labels for each button in the
    group.
- name: values
  description: |-
    A vector of values specifying the values of each button in the
    group, defaults to `labels`.
- name: enable
  description: |-
    One of `values` indicating individual buttons to enable or
    `TRUE` to enable the entire input, defaults to `NULL`.
- name: disable
  description: |-
    One of `values` indicating individual buttons to disable or
    `TRUE` to disable the entire input, defaults to `NULL`.
family: inputs
export: ''
examples:
- title: Default input
  body:
  - type: code
    content: |-
      buttonGroupInput(
        id = "group1",
        labels = c("Once", "Twice", "Thrice"),
        values = c(1, 2, 3)
      )
    output: |-
      <div class="yonder-button-group btn-group" id="group1" role="group">
        <button type="button" class="btn btn-grey" value="1">Once</button>
        <button type="button" class="btn btn-grey" value="2">Twice</button>
        <button type="button" class="btn btn-grey" value="3">Thrice</button>
      </div>
- title: Styling the button group
  body:
  - type: code
    content: |-
      buttonGroupInput(
        id = "group2",
        labels = c("Button 1", "Button 2", "Button 3")
      ) %>%
        background("blue") %>%
        width("1/3")
    output: |-
      <div class="yonder-button-group btn-group w-1/3" id="group2" role="group">
        <button type="button" class="btn btn-blue" value="Button 1">Button 1</button>
        <button type="button" class="btn btn-blue" value="Button 2">Button 2</button>
        <button type="button" class="btn btn-blue" value="Button 3">Button 3</button>
      </div>
rdname: updateButtonGroupInput
sections: []
layout: doc
---
