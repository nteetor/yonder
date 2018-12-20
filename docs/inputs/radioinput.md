---
name: radioInput
title: Radio inputs
description: Create a reactive radio input of one or more radio controls.
parameters:
- name: choices
  description: |-
    A character vector specifying labels for the radio or radiobar
    input's choices.
- name: values
  description: |-
    A character vector, list of character strings, vector of values
    to coerce to character strings, or list of values to coerce to character
    strings specifying the values of the radio input's choices, defaults to
    `choices`.
- name: selected
  description: |-
    One of `values` indicating the default selected value of the
    radio input, defaults to `NULL`, in which case the first choice is
    selected by default.
- name: help
  description: |-
    A character string specifying a small help label which appears
    below the input, defaults to `NULL` in which case help text is not added.
- name: inline
  description: |-
    If `TRUE`, the radio input renders inline, defaults to `FALSE`,
    in which case the radio controls render on separate lines.
- name: disabled
  description: |-
    One or more of `values` indicating which radio choices to
    disable, defaults to `NULL`, in which case all choices are enabled.
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: Additional named arguments passed as HTML attributes to the parent
    element.
family: inputs
export: ''
examples:
- title: '## Stacked radio input'
  body:
  - code: |-
      radioInput(
        id = "stacked",
        choices = c(
          "Vehicula adipiscing mattis",
          "Magna nullam",
          "Aenean venenatis",
          "Tristique quam porta"
        )
      )
    output: |-
      <div class="yonder-radio" id="stacked">
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-887-485" name="stacked" value="Vehicula adipiscing mattis" checked/>
          <label class="custom-control-label" for="radio-887-485">Vehicula adipiscing mattis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-178-405" name="stacked" value="Magna nullam"/>
          <label class="custom-control-label" for="radio-178-405">Magna nullam</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-778-148" name="stacked" value="Aenean venenatis"/>
          <label class="custom-control-label" for="radio-778-148">Aenean venenatis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-575-301" name="stacked" value="Tristique quam porta"/>
          <label class="custom-control-label" for="radio-575-301">Tristique quam porta</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
- title: '## Inline radio input'
  body:
  - code: |-
      radioInput(
        id = "inline",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        ),
        inline = TRUE  # <-
      )
    output: |-
      <div class="yonder-radio" id="inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-757-418" name="inline" value="Choice 1" checked/>
          <label class="custom-control-label" for="radio-757-418">Choice 1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-807-946" name="inline" value="Choice 2"/>
          <label class="custom-control-label" for="radio-807-946">Choice 2</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-137-983" name="inline" value="Choice 3"/>
          <label class="custom-control-label" for="radio-137-983">Choice 3</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
- title: '## Radiobars in comparison'
  body:
  - code: |-
      radiobarInput(
        id = NULL,
        choices = c(
          "fusce sagittis",
          "libero non molestie",
          "magna orci",
          "ultrices dolor"
        ),
        selected = "ultrices dolor"
      ) %>%
        background("grey")
    output: |-
      <div class="yonder-radiobar btn-group btn-group-toggle" data-toggle="buttons">
        <label class="btn btn-grey">
          <input type="radio" data-value="fusce sagittis" autocomplete="false"/>
          <span>fusce sagittis</span>
        </label>
        <label class="btn btn-grey">
          <input type="radio" data-value="libero non molestie" autocomplete="false"/>
          <span>libero non molestie</span>
        </label>
        <label class="btn btn-grey">
          <input type="radio" data-value="magna orci" autocomplete="false"/>
          <span>magna orci</span>
        </label>
        <label class="btn active btn-grey">
          <input type="radio" data-value="ultrices dolor" autocomplete="false" checked/>
          <span>ultrices dolor</span>
        </label>
      </div>
layout: doc
---
