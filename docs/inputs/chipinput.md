---
name: chipInput
title: A chips input
description: A selectize alternative.
inheritParams: buttonInput
parameters:
- name: choices
  description: A character vector or list specifying the possible choices.
- name: values
  description: |-
    A character vector or list of strings specifying the input's
    values, defaults to `choices`.
- name: selected
  description: |-
    One or more of `values` specifying which values are selected
    by default.
- name: max
  description: A number specifying the maximum number of items a user may select.
- name: fill
  description: |-
    One of `TRUE` or `FALSE` specifying the layout of chips. If
    `TRUE` chips fill the width of the parent element, otherwise if `FALSE` the
    chips are rendered inline, defaults to `TRUE`.
sections:
- title: '**Example** simple application'
  body: |-
    ```R
    ui <- container(
      chipInput(
        id = "chips",
        choices = paste("Option number", 1:10),
        values = 1:10,
        fill = TRUE
      ) %>%
        width("1/2")
    )

    server <- function(input, output) {

    }

    shinyApp(ui, server)
    ```
- title: '**Example** inline chips'
  body: |-
    ```R
    ui <- container(
      chipInput(
        id = "chips",
        choices = c(
          "A rather long option, isn't it?",
          "Shorter",
          "A middle-size option",
          "One more"
        ),
        values = 1:4,
        fill = FALSE
      ) %>%
        width("1/2") %>%
        background("blue") %>%
        shadow("small")
    )

    server <- function(input, output) {

    }

    shinyApp(ui, server)
    ```
family: inputs
export: ''
examples:
- title: Default input
  body:
  - type: code
    content: |-
      chipInput(
        id = "chip1",
        choices = paste("Choice", 1:5)
      )
    output: |-
      <div id="chip1" class="yonder-chip btn-group dropup" data-max="-1">
        <input class="form-control form-control-sm" data-toggle="dropdown"/>
        <div class="dropdown-menu">
          <button class="dropdown-item" value="Choice 1">Choice 1</button>
          <button class="dropdown-item" value="Choice 2">Choice 2</button>
          <button class="dropdown-item" value="Choice 3">Choice 3</button>
          <button class="dropdown-item" value="Choice 4">Choice 4</button>
          <button class="dropdown-item" value="Choice 5">Choice 5</button>
        </div>
        <div class="chips chips-block chips-grey">
          <button class="chip" value="Choice 1">
            <span class="chip-content">Choice 1</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 2">
            <span class="chip-content">Choice 2</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 3">
            <span class="chip-content">Choice 3</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 4">
            <span class="chip-content">Choice 4</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 5">
            <span class="chip-content">Choice 5</span>
            <span class="chip-close">&times;</span>
          </button>
        </div>
      </div>
rdname: chipInput
layout: doc
---
