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
  sections:
  - title: Reactive value
    body: |-
      A click on a navigation link triggers a single character string.

      A click on a dropdown item triggers a character vector of two values, the
      value of the nav link and the value of the dropdown item.
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Nav styled as tabs</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs1",
        choices = c(
          "Tab 1",
          "Tab 2",
          "Tab 3"
        ),
        appearance = "tabs"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-tabs" id="tabs1">
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
        id = "tabs2",
        choices = paste("Tab", 1:3),
        appearance = "pills"
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-pills" id="tabs2">
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
        id = "tabs3",
        choices = list(
          "Tab 1",
          menuInput(
            id = NULL,  # <- ignored
            label = "Tab 2",
            choices = c(
              "Action",
              "Another action"
            )
          ),
          "Tab 2"
        ),
        values = c("tab1", "tab2", "tab3")
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav" id="tabs3">
        <li class="nav-item">
          <a class="nav-link active" href="#" data-value="tab1">Tab 1</a>
        </li>
        <li class="yonder-menu dropdown nav-item">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" data-value="tab2">Tab 2</a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="#" data-value="Action">Action</a>
            <a class="dropdown-item" href="#" data-value="Another action">Another action</a>
          </div>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-value="tab3">Tab 2</a>
        </li>
      </ul>
  - type: markdown
    value: |
      <h3>Full width nav input</h3>
  - type: source
    value: |2-

      navInput(
        id = "tabs4",
        choices = paste("Tab", 1:5),
        values = paste0("tab", 1:5),
        appearance = "pills",
        fill = TRUE
      )
  - type: output
    value: |-
      <ul class="yonder-nav nav nav-fill nav-pills" id="tabs4">
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
        id = "tabs5",
        choices = paste("Tab", 1:3)
      ) %>%
        flex(justify = "center")
  - type: output
    value: |-
      <ul class="yonder-nav nav justify-content-center" id="tabs5">
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
