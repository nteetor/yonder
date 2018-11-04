---
this: navInput
filename: R/nav.R
layout: page
requires: ~
roxygen:
  title: Page navigation
  description: |-
    A reactive input styled as a navigation control. The navigation input can be
    styled as links, tabs, or pills. A nav input is paired with [navContent()](/yonder/0.0.5/content/navContent.html)
    and [showPane()](/yonder/0.0.5/content/showPane.html) to create tabbed user interfaces.
  parameters:
  - name: id
    description: A character string specifying the id of a pane.
  - name: choices
    description: |-
      A character vector or list of tag elements specifying the
      navigation items of the navigation input.
  - name: values
    description: |-
      A character vector specifying custom values for each navigation
      item, defaults to `labels`.
  - name: fill
    description: |-
      One of `TRUE` or `FALSE` specifying if the nav input fills the
      width of its parent element. If `TRUE`, the space is divided evenly among
      the nav items.
  - name: appearance
    description: |-
      One of `"pills"` or `"tabs"` specifying the appearance of
      the nav input.
  - name: '...'
    description: |-
      Any number of tag elements or named arguments passed as HTML
      attributes to the parent element.
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Nav styled as tabs</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        choices = c(
          "Tab 1",
          "Tab 2",
          "Tab 3"
        ),
        appearance = "tabs"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-tabs" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Nav styled as pills</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        choices = paste("Tab", 1:3),
        appearance = "pills"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-pills" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Nav with dropdown</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        choices = list(
          "Tab 1",
          dropdown(
            label = "Tab 2",
            buttonInput("action", "Action"),
            buttonInput("another", "Another action")
          ),
          "Tab 2"
        )
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="dropdown nav-item">
          <a class="nav-link dropdown-toggle" data-toggle="dropdown" aria-haspop="true" aria-expanded="false" data-value="Tab 2" role="button" href="#">Tab 2</a>
          <div class="dropdown-menu">
            <button class="yonder-button dropdown-item" type="button" role="button" id="action">Action</button>
            <button class="yonder-button dropdown-item" type="button" role="button" id="another">Another action</button>
          </div>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Full width nav input</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        choices = paste("Tab", 1:5),
        values = paste0("tab", 1:5),
        appearance = "pills",
        fill = TRUE
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-fill nav-pills" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="tab1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="tab2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="tab3">Tab 3</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="tab4">Tab 4</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="tab5">Tab 5</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Centering a nav input</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs",
        choices = paste("Tab", 1:3)
      ) %>%
        flex(justify = "center")
  - type: output
    value: |-
      <ul class="yonder-nav nav justify-content-center" id="tabs">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="Tab 1">Tab 1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 2">Tab 2</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="Tab 3">Tab 3</a>
        </li>
      </ul>
---
