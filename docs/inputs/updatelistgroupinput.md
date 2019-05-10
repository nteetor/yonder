---
name: updateListGroupInput
title: List group inputs
description: |-
  List group inputs are an actionable list of items. They behave similarly to
  checkboxes or radios, that is, users may select one or more items from the
  list. However, list group items may include highly variable content.
inheritParams: checkboxInput
parameters:
- name: choices
  description: |-
    A vector of character strings or list of tag elements specifying
    the content of the list group's items.
- name: values
  description: |-
    A character vector specifying the values of the list items,
    defaults to `choices`.
- name: selected
  description: |-
    One or more of `values` specifying which choices are selected
    by default, defaults to `NULL`, in which case no choice is selected.
- name: layout
  description: |-
    A [responsive](layout/responsive.html) argument. One of `"vertical"` or `"horizontal"`
    specifying how list items are laid out, defaults to `"vertical"`. Note, if
    `layout` is `"horizontal"` and the `flush` argument is ignored.
- name: flush
  description: |-
    One of `TRUE` or `FALSE` specifying if the list group is
    rendered without an outside border, defaults to `FALSE`. Removing the list
    group border is useful when rendering a list group inside a custom parent
    container, e.g. inside a [card()](content/card.html).
sections:
- title: Navigation with a list group
  body: |-
    A list group can also control a set of panes. Be sure to set `multiple =
    FALSE`. This layout is reminiscent of a table of contents.

    ```R
    ui <- container(
      columns(
        column(
          width = 3,
          listGroupInput(
            id = "nav",
            selected = "pane1",
            choices = c(
              "Item 1",
              "Item 2",
              "Item 3"
            ),
            values = c(
              "pane1",
              "pane2",
              "pane3"
            )
          )
        ),
        column(
          navContent(
            navPane(
              id = "pane1",
              p("Pellentesque tristique imperdiet tortor.")
            ),
            navPane(
              id = "pane2",
              p("Sed bibendum. Donec pretium posuere tellus.")
            ),
            navPane(
              id = "pane3",
              p("Pellentesque tristique imperdiet tortor.")
            )
          )
        )
      )
    )

    server <- function(input, output) {
      observeEvent(input$nav, {
        showPane(input$nav)
      })
    }

    shinyApp(ui, server)
    ```
family: inputs
export: ''
examples:
- title: An actionable list group
  body:
  - type: code
    content: |-
      listGroupInput(
        id = "list1",
        choices = paste("Item", 1:5)
      )
    output: |-
      <div class="yonder-list-group list-group" id="list1">
        <button class="list-group-item list-group-item-action" value="Item 1">Item 1</button>
        <button class="list-group-item list-group-item-action" value="Item 2">Item 2</button>
        <button class="list-group-item list-group-item-action" value="Item 3">Item 3</button>
        <button class="list-group-item list-group-item-action" value="Item 4">Item 4</button>
        <button class="list-group-item list-group-item-action" value="Item 5">Item 5</button>
      </div>
- title: List group within a card
  body:
  - type: code
    content: |-
      card(
        header = h6("Pick an item"),
        listGroupInput(
          id = "list2",
          flush = TRUE,
          choices = paste("Item", 1:5),
        )
      )
    output: |-
      <div class="card">
        <div class="card-header">
          <h6>Pick an item</h6>
        </div>
        <div class="yonder-list-group list-group list-group-flush" id="list2">
          <button class="list-group-item list-group-item-action" value="Item 1">Item 1</button>
          <button class="list-group-item list-group-item-action" value="Item 2">Item 2</button>
          <button class="list-group-item list-group-item-action" value="Item 3">Item 3</button>
          <button class="list-group-item list-group-item-action" value="Item 4">Item 4</button>
          <button class="list-group-item list-group-item-action" value="Item 5">Item 5</button>
        </div>
      </div>
- title: Horizontal list group
  body:
  - type: code
    content: |-
      listGroupInput(
        id = "list3",
        choices = paste("Item", 1:4),
        layout = "horizontal"
      )
    output: |-
      <div class="yonder-list-group list-group list-group-horizontal" id="list3">
        <button class="list-group-item list-group-item-action" value="Item 1">Item 1</button>
        <button class="list-group-item list-group-item-action" value="Item 2">Item 2</button>
        <button class="list-group-item list-group-item-action" value="Item 3">Item 3</button>
        <button class="list-group-item list-group-item-action" value="Item 4">Item 4</button>
      </div>
rdname: updateListGroupInput
layout: doc
---
