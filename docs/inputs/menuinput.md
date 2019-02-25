---
name: menuInput
title: Menu input
description: |-
  A togglable dropdown menu input. Menu inputs may be used as standalone
  reactive inputs or within a [navInput()]. For building custom, more complex
  dropdown elements please see [dropdown()].
inheritParams: buttonInput
parameters:
- name: label
  description: |-
    A character string or tag element specifying the label of the
    menu's toggle button.
- name: choices
  description: |-
    A character vector specifying the choice text of the menu's
    items.
- name: values
  description: |-
    A character vector specifying the values of the menu's items,
    defaults to `choices`.
- name: direction
  description: |-
    One of `"up"`, `"right"`, `"down"`, or `"left"` specifying
    which direction the menu opens, defaults to `"down"`.
- name: align
  description: |-
    One or `"right"` or `"left"` specifying which side of the
    toggle button the menu aligns to, defaults to `"left"`.`
family: inputs
export: ''
examples:
- title: A simple menu
  body:
  - type: code
    content: |-
      menuInput(
        id = "menu1",
        label = "Menu",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        )
      )
    output: |-
      <div class="yonder-menu dropdown" id="menu1">
        <button class="btn btn-grey dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Menu</button>
        <div class="dropdown-menu">
          <button class="dropdown-item" type="button" value="Choice 1">Choice 1</button>
          <button class="dropdown-item" type="button" value="Choice 2">Choice 2</button>
          <button class="dropdown-item" type="button" value="Choice 3">Choice 3</button>
        </div>
      </div>
- title: Use in navigation
  body:
  - type: code
    content: |-
      navInput(
        id = "nav1",
        choices = list(
          "Tab 1",
          menuInput(
            id = "navOptions",
            label = "Tab 2",
            choices = c(
              "Option 1",
              "Option 2",
              "Option 3"
            )
          ),
          "Tab 3",
          "Tab 4"
        ),
        values = paste0("tab", 1:4)
      )
    output: |-
      <ul class="yonder-nav nav" id="nav1">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="tab1">Tab 1</button>
        </li>
        <li class="yonder-menu dropdown nav-item" id="navOptions">
          <button class="btn dropdown-toggle nav-link btn-link" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" value="tab2">Tab 2</button>
          <div class="dropdown-menu">
            <button class="dropdown-item" type="button" value="Option 1">Option 1</button>
            <button class="dropdown-item" type="button" value="Option 2">Option 2</button>
            <button class="dropdown-item" type="button" value="Option 3">Option 3</button>
          </div>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab3">Tab 3</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab4">Tab 4</button>
        </li>
      </ul>
rdname: menuInput
sections: []
layout: doc
---
