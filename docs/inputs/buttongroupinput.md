---
name: buttonGroupInput
title: Button group inputs
description: A set of buttons with custom values.
parameters:
- name: labels
  description: |-
    A character vector of labels, a button is added to the group
    for each label specified.
- name: values
  description: |-
    A character vector of values, one for each button specified,
    defaults to `labels`.
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: Additional named arguments passed as HTML attributes to the parent
    element.
family: inputs
export: ''
examples:
- title: Default input
  body:
  - type: code
    content: |-
      buttonGroupInput(
        id = NULL,
        labels = c("Once", "Twice", "Thrice"),
        values = c(1, 2, 3)
      )
    output: |-
      <div class="yonder-button-group btn-group" role="group">
        <button type="button" class="btn btn-grey" value="1">Once</button>
        <button type="button" class="btn btn-grey" value="2">Twice</button>
        <button type="button" class="btn btn-grey" value="3">Thrice</button>
      </div>
- title: Styling the button group
  body:
  - type: code
    content: |-
      buttonGroupInput(
        id = NULL,
        labels = c("Button 1", "Button 2", "Button 3")
      ) %>%
        background("blue") %>%
        margin(3)
    output: |-
      <div class="yonder-button-group btn-group m-3" role="group">
        <button type="button" class="btn btn-blue" value="Button 1">Button 1</button>
        <button type="button" class="btn btn-blue" value="Button 2">Button 2</button>
        <button type="button" class="btn btn-blue" value="Button 3">Button 3</button>
      </div>
rdname: buttonGroupInput
sections: []
layout: doc
---
