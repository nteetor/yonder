---
name: updateSelectInput
title: Select input
description: |-
  Create a select input. Select elements typically appear as a simple menu of
  choices and may have one or more selected values, see the `multiple`
  argument. A group select input is a select input with one or two additional
  components. These addon components are used to change the reactivity or value
  of the input, see Details for more information.
inheritParams: checkboxInput
parameters:
- name: choices
  description: A character vector specifying the input's choices.
- name: values
  description: |-
    A character vector specifying the values of the input's
    choices, defaults to `choices`.
- name: selected
  description: |-
    One of `values` indicating the default value of the input,
    defaults to `values[[1]]`.
- name: left,right
  description: |-
    A character vector specifying static addons or
    [buttonInput()](inputs/buttoninput.html) or [dropdown()](content/dropdown.html) elements specifying dynamic addons. Addons
    affect the reactive value of the group input, see the Details section below
    for more information.

    **`left` is character or `right` is character**

    If `left` or `right` are character vectors, then the group input functions
    like a text input. The value will update and trigger a reactive event when
    the text box is modified. The group input's reactive value is the
    concatention of the static addons specified by `left` or `right` and the
    value of the text input.

    **`left` is button or `right` is button**

    The button does not change the value of the group input. However, the input
    no longer triggers event when the text box is updated. Instead the value is
    updated when a button is clicked. Static addons are still applied to the
    group input value.

    **`left` is a dropdown or `right` is a dropdown**

    The value of the group input does chance depending on the clicked dropdown
    menu item. The value of the input group is the concatentation of the
    dropdown input value, the value of the text input, and any static addons.
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
      <div class="yonder-select btn-group">
        <input type="text" class="form-control custom-select" data-toggle="dropdown" placeholder/>
        <div class="dropdown-menu">
          <button class="dropdown-item">Choose one</button>
          <button class="dropdown-item" value="1">Choice 1</button>
          <button class="dropdown-item" value="2">Choice 2</button>
          <button class="dropdown-item" value="3">Choice 3</button>
        </div>
        <div class="valid-feedback"></div>
        <div class="invalid-feedback"></div>
      </div>
rdname: updateSelectInput
sections: []
layout: doc
---
