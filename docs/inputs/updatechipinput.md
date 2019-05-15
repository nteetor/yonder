---
name: updateChipInput
title: Chip input, selectize alternative
description: |-
  The chip input is a selectize alternative. Choices are selected from a
  dropdown menu and appear as chips below the input's text box. Chips do not
  appear in the order they are selected. Instead chips are shown in the order
  specified by the `choices` argument. Use the `max` argument to limit the
  number of choices a user may select.
inheritParams: checkboxInput
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
  description: |-
    A number specifying the maximum number of items a user may select,
    defaults to `Inf`.
- name: inline
  description: |-
    One of `TRUE` or `FALSE` specifying if chips are rendered
    inline. If `TRUE` multiple chips may fit onto a single row, otherwise, if
    `FALSE`, chips expand to fill the width of their parent element, one chip
    per row.
sections:
- title: '**Example** simple application'
  body: |-
    ```R
    ui <- container(
      chipInput(
        id = "chips",
        choices = paste("Option number", 1:10),
        values = 1:10,
        inline = TRUE
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
        choices = paste("Choice", 1:5),
        selected = c("Choice 3", "Choice 4")
      )
    output: |-
      <div id="chip1" class="yonder-chip btn-group dropup" data-max="-1">
        <input class="form-control" data-toggle="dropdown"/>
        <div class="dropdown-menu">
          <button class="dropdown-item" value="Choice 1">Choice 1</button>
          <button class="dropdown-item" value="Choice 2">Choice 2</button>
          <button class="dropdown-item selected" value="Choice 3">Choice 3</button>
          <button class="dropdown-item selected" value="Choice 4">Choice 4</button>
          <button class="dropdown-item" value="Choice 5">Choice 5</button>
        </div>
        <div class="chips chips-inline chips-grey">
          <button class="chip" value="Choice 1">
            <span class="chip-content">Choice 1</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 2">
            <span class="chip-content">Choice 2</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip active" value="Choice 3">
            <span class="chip-content">Choice 3</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip active" value="Choice 4">
            <span class="chip-content">Choice 4</span>
            <span class="chip-close">&times;</span>
          </button>
          <button class="chip" value="Choice 5">
            <span class="chip-content">Choice 5</span>
            <span class="chip-close">&times;</span>
          </button>
        </div>
      </div>
rdname: updateChipInput
layout: doc
---
