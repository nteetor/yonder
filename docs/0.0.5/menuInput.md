---
this: menuInput
filename: R/menu.R
layout: page
requires: ~
roxygen:
  title: Menu input
  description: |-
    A togglable dropdown menu input. Menu inputs may be used as standalone
    reactive inputs or within a [navInput()](/yonder/0.0.5/navInput.html). When used within a nav input the
    `id` argument is ignored and may be set to `NULL`. For building custom,
    more complex dropdown elements please see [dropdown()](/yonder/0.0.5/content/dropdown.html).
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
  sections: []
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>A simple menu</h3>
  - type: source
    value: |2-

      menuInput(
        id = "menu1",
        label = "Menu",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        )
      )
  - type: output
    value: |-
      <div class="yonder-menu dropdown" id="menu1">
        <a class="btn btn-grey dropdown-toggle" href="#" role="button" data-toggle="dropdown">Menu</a>
        <div class="dropdown-menu">
          <a class="dropdown-item" href="#" data-value="Choice 1">Choice 1</a>
          <a class="dropdown-item" href="#" data-value="Choice 2">Choice 2</a>
          <a class="dropdown-item" href="#" data-value="Choice 3">Choice 3</a>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Use in navigation</h3>
  - type: source
    value: |2-

      navInput(
        id = "nav1",
        choice = list(
          "Tab 1",
          menuInput(
            id = NULL,  # <- ignored
            label = "Tab 2",
            choices = c(
              "Option 1",
              "Option 2",
              "Option 3"
            )
          ),
          "Tab 3",
          "Tab 4"
        )
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav" id="nav1">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="yonder-menu dropdown nav-item">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" data-value="Tab 2">Tab 2</a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="#" data-value="Option 1">Option 1</a>
            <a class="dropdown-item" href="#" data-value="Option 2">Option 2</a>
            <a class="dropdown-item" href="#" data-value="Option 3">Option 3</a>
          </div>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 4">Tab 4</a>
        </li>
      </ul>
---
