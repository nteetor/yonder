---
name: groupInput
title: Group inputs, combination button, dropdown, and text input
description: |-
  A group input is a combination reactive input which may consist of one or two
  buttons, dropdowns, static addons, or any combination of these elements.
  Static addons, specified with `left` and `right` may be used to ensure an
  group input's reactive value always has a certain prefix or suffix. These
  static addons render with a shaded background to help indicated this behavior
  to the user. Buttons and dropdowns may be included to control when the group
  input's reactive value updates. See Details for more information.
inheritParams: buttonInput
parameters:
- name: placeholder
  description: |-
    A character string specifying placeholder text for the
    input group, defaults to `NULL`.
- name: value
  description: |-
    A character string specifying an initial value for the input
    group, defaults to `NULL`.
- name: left,right
  description: |-
    A character vector specifying static addons or
    [buttonInput()](inputs/buttoninput.html) or [dropdown()](content/dropdown.html) elements specifying dynamic addons.
    Addon's affect the reactive value of the group input, see the Details
    section below for more information.
sections:
- title: '`left` and `right` combinations'
  body: |-
    **`left` is character or `right` is character**

    If `left` or `right` are character vectors, then the group input functions
    like a text input. The value will update and trigger a reactive event when
    the text box is modified. The group input's reactive value is the
    concatention of the static addons specified by `left` or `right` and the
    value of the text input.

    **`left` is button or `right` is button**

    The button does not change the value of the group input. However, the input
    no longer triggers event when the text box is updated. Instead the value
    is updated when a button is clicked. Static addons are still applied to the
    group input value.

    **`left` is a dropdown or `right` is a dropdown**

    The value of the group input does chance depending on the clicked dropdown
    menu item. The value of the input group is the concatentation of the
    dropdown input value, the value of the text input, and any static addons.
family: inputs
export: ''
examples:
- title: Simple character string addon
  body:
  - type: text
    content: This input will always append a "@".
    output: ~
  - type: code
    content: |-
      groupInput(
        id = "group1",
        left = "@",
        placeholder = "Username"
      )
    output: |-
      <div class="yonder-group input-group" id="group1">
        <div class="input-group-prepend">
          <span class="input-group-text">@</span>
        </div>
        <input type="text" class="form-control" placeholder="Username"/>
      </div>
- title: Text input and button combo
  body:
  - type: code
    content: |-
      groupInput(
        id = "group2",
        placeholder = "Search terms",
        right = buttonInput(
          id = "button2",
          label = "Go!"
        ) %>%
          background("grey") %>%
          border()
      )
    output: |-
      <div class="yonder-group input-group" id="group2">
        <input type="text" class="form-control" placeholder="Search terms"/>
        <div class="input-group-append">
          <button class="yonder-button btn btn-grey border" type="button" role="button" id="button2">Go!</button>
        </div>
      </div>
- title: Combination addon
  body:
  - type: code
    content: |-
      groupInput(
        id = "group3",
        left = c("$", "0.")
      )
    output: |-
      <div class="yonder-group input-group" id="group3">
        <div class="input-group-prepend">
          <span class="input-group-text">$</span>
          <span class="input-group-text">0.</span>
        </div>
        <input type="text" class="form-control"/>
      </div>
- title: Two addons
  body:
  - type: code
    content: |-
      groupInput(
        id = "group4",
        left = "@",
        placeholder = "Username",
        right = buttonInput(
          id = "button4",
          label = "Search"
        ) %>%
          background("blue")
      )
    output: |-
      <div class="yonder-group input-group" id="group4">
        <div class="input-group-prepend">
          <span class="input-group-text">@</span>
        </div>
        <input type="text" class="form-control" placeholder="Username"/>
        <div class="input-group-append">
          <button class="yonder-button btn btn-blue" type="button" role="button" id="button4">Search</button>
        </div>
      </div>
rdname: groupInput
layout: doc
---
