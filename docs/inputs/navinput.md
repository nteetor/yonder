---
name: navInput
title: Page navigation input
description: |-
  A reactive input styled as a navigation control. The navigation input can be
  styled as links, tabs, or pills. A nav input is paired with [navContent()]
  and [showNavPane()] to create tabbed user interfaces. Observers and reactives
  are triggered when a nav choice or menu item is clicked. The reactive value
  of a nav input is `NULL` or a singleton character string. The value of any
  menus in the nav input must be retrieved with its own reactive id.
inheritParams: checkboxInput
parameters:
- name: choices
  description: |-
    A character vector or list of tag elements specifying the
    navigation items of the input.
- name: values
  description: |-
    A character vector specifying the values of the input's
    chocies, defaults to `choices`.
- name: selected
  description: |-
    One of `values` specifying which choice is selected by
    default, defaults to `values[[1]]`.
- name: fill
  description: |-
    One of `TRUE` or `FALSE` specifying if the nav input fills the
    width of its parent element. If `TRUE`, the space is divided evenly among
    the nav items.
- name: appearance
  description: |-
    One of `"links"`, `"pills"`, or `"tabs"` specifying the
    appearance of the nav input, defaults to `"links"`.
sections:
- title: Including a menu
  body: |-
    Use the reactive id of any nav menus to know when a menu item is clicked.

    ```R
    ui <- navInput(
      id = "navigation",
      choices = list(
        "Item 1",
        "Item 2",
        menuInput(
          id = "navMenu",  # <-
          label = "Item 3",
          choices = c("Choice 1", "Choice 2")
        )
      ),
      values = c("item1", "item2", "item3")
    )

    server <- function(input, output) {
      observeEvent(input$navMenu, {
        cat(paste("Click menu item:", input$navMenu, "\n"))
      })
    }

    shinyApp(ui, server)
    ```
family: inputs
export: ''
examples:
- title: Nav styled as tabs
  body:
  - type: code
    content: |-
      navInput(
        id = "tabs1",
        choices = c(
          "Tab 1",
          "Tab 2",
          "Tab 3"
        ),
        selected = "Tab 1",
        appearance = "tabs"
      )
    output: |-
      <ul class="yonder-nav nav nav-tabs" id="tabs1">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="Tab 1">Tab 1</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 2">Tab 2</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 3">Tab 3</button>
        </li>
      </ul>
- title: Nav styled as pills
  body:
  - type: code
    content: |-
      navInput(
        id = "tabs2",
        choices = paste("Tab", 1:3),
        selected = "Tab 1",
        appearance = "pills"
      )
    output: |-
      <ul class="yonder-nav nav nav-pills" id="tabs2">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="Tab 1">Tab 1</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 2">Tab 2</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 3">Tab 3</button>
        </li>
      </ul>
- title: Nav with dropdown
  body:
  - type: code
    content: |-
      navInput(
        id = "tabs3",
        choices = list(
          "Tab 1",
          menuInput(
            id = "menu1",
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
    output: |-
      <ul class="yonder-nav nav" id="tabs3">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="tab1">Tab 1</button>
        </li>
        <li class="yonder-menu dropdown nav-item" id="menu1">
          <button class="btn dropdown-toggle nav-link btn-link" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" value="tab2">Tab 2</button>
          <div class="dropdown-menu">
            <button class="dropdown-item" type="button" value="Action">Action</button>
            <button class="dropdown-item" type="button" value="Another action">Another action</button>
          </div>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab3">Tab 2</button>
        </li>
      </ul>
- title: Full width nav input
  body:
  - type: code
    content: |-
      navInput(
        id = "tabs4",
        choices = paste("Tab", 1:5),
        values = paste0("tab", 1:5),
        appearance = "pills",
        fill = TRUE
      )
    output: |-
      <ul class="yonder-nav nav nav-fill nav-pills" id="tabs4">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="tab1">Tab 1</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab2">Tab 2</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab3">Tab 3</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab4">Tab 4</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="tab5">Tab 5</button>
        </li>
      </ul>
- title: Centering a nav input
  body:
  - type: code
    content: |-
      navInput(
        id = "tabs5",
        choices = paste("Tab", 1:3)
      ) %>%
        flex(justify = "center")
    output: |-
      <ul class="yonder-nav nav justify-content-center" id="tabs5">
        <li class="nav-item">
          <button class="nav-link btn btn-link active" value="Tab 1">Tab 1</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 2">Tab 2</button>
        </li>
        <li class="nav-item">
          <button class="nav-link btn btn-link" value="Tab 3">Tab 3</button>
        </li>
      </ul>
rdname: navInput
layout: doc
---
