---
name: listGroupInput
title: List group inputs
description: |-
  List group inputs are an actionable list of items. They behave similarly to
  checkboxes or radios, that is, users may select one or more items from the
  list. However, list group items may include highly variable content.
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
- name: multiple
  description: |-
    One of `TRUE` or `FALSE` specifyng if multiple list group
    items may be selected, defaults to `TRUE`.
- name: flush
  description: |-
    One of `TRUE` or `FALSE` specifying if the list group is
    rendered without an outside border, defaults to `FALSE`. Removing the list
    group border is useful when rendering a list group inside a custom parent
    container, e.g. inside a [card()].
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: Additional named arguments passed as HTML attributes to the parent
    element.
sections:
- title: Complex list items
  body: |-
    The following application demonstrates the flexibility of a list
    group input. Here each list item contains a collasible pane. We
    can hook up the server such that selecting a list item expands the
    corresponding collapsible pane.

    ```R
    lessons <- list(
      stars = c(
        "The stars and moon are far too bright",
        "Their beam and smile splashing o'er all",
        "To illuminate while turning sight",
        "From shadows wherein deeper shadows fall"
      ),
      joy = c(
        "A single step, her hand aloft",
        "More than a step, a joyful bound",
        "The moment, precious, small, soft",
        "And within a truth was found"
      )
    )

    ui <- container(
      listGroupInput(
        id = "poems",
        multiple = FALSE,
        choices = list(
          list(
            h5("Stars"),
            collapsiblePane(
              id = "stars",
              lapply(lessons[["stars"]], tags$p)
            )
          ),
          list(
            h5("Joy"),
            collapsiblePane(
              id = "joy",
              lapply(lessons[["joy"]], tags$p)
            )
          )
        ),
        values = c("stars", "joy")
      )
    )

    server <- function(input, output) {
      observeEvent(input$poems, {
        if (input$poems == "stars") {
          collapsePane("joy")
          expandPane("stars")
        } else {
          collapsePane("stars")
          expandPane("joy")
        }
      })
    }

    shinyApp(ui, server)
    ```
- title: Navigation with a list group
  body: |-
    A list group can also control a set of panes. Be sure to set `multiple =
    FALSE`. This layout is reminiscent of a table of contents.

    ```R
    ui <- container(
      row(
        column(
          width = 3,
          listGroupInput(
            id = "nav",
            multiple = FALSE,
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
- title: '## A simple list group'
  body:
  - code: ''
    output: []
- title: This list group is not actionable as `id` is `NULL`.
  body:
  - code: |-
      listGroupInput(
        id = NULL,
        choices = paste("Item", 1:5)
      )
    output: |-
      <ul class="yonder-list-group list-group" data-multiple="true">
        <li class="list-group-item" data-value="Item 1">Item 1</li>
        <li class="list-group-item" data-value="Item 2">Item 2</li>
        <li class="list-group-item" data-value="Item 3">Item 3</li>
        <li class="list-group-item" data-value="Item 4">Item 4</li>
        <li class="list-group-item" data-value="Item 5">Item 5</li>
      </ul>
- title: '# An actionable list group'
  body:
  - code: ''
    output: []
- title: In this example we specify an `id` thus creating an actionable list group.
  body:
  - code: |-
      listGroupInput(
        id = "list1",
        choices = paste("Item", 1:5)
      )
    output: |-
      <div class="yonder-list-group list-group" data-multiple="true" id="list1">
        <a class="list-group-item list-group-item-action" data-value="Item 1">Item 1</a>
        <a class="list-group-item list-group-item-action" data-value="Item 2">Item 2</a>
        <a class="list-group-item list-group-item-action" data-value="Item 3">Item 3</a>
        <a class="list-group-item list-group-item-action" data-value="Item 4">Item 4</a>
        <a class="list-group-item list-group-item-action" data-value="Item 5">Item 5</a>
      </div>
- title: '# List group within a card'
  body:
  - code: |-
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
        <h6 class="card-header">Pick an item</h6>
        <div class="yonder-list-group list-group list-group-flush" data-multiple="true" id="list2">
          <a class="list-group-item list-group-item-action" data-value="Item 1">Item 1</a>
          <a class="list-group-item list-group-item-action" data-value="Item 2">Item 2</a>
          <a class="list-group-item list-group-item-action" data-value="Item 3">Item 3</a>
          <a class="list-group-item list-group-item-action" data-value="Item 4">Item 4</a>
          <a class="list-group-item list-group-item-action" data-value="Item 5">Item 5</a>
        </div>
      </div>
layout: doc
---
