---
name: radioInput
title: Radio inputs
description: Create a reactive radio input of one or more radio controls.
inheritParams: buttonInput
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
- name: inline
  description: |-
    If `TRUE`, the radio input renders inline, defaults to `FALSE`,
    in which case the radio controls render on separate lines.
- name: disabled
  description: |-
    One or more of `values` indicating which radio choices to
    disable, defaults to `NULL`, in which case all choices are enabled.
family: inputs
export: ''
examples:
- title: Out-of-the-box radios
  body:
  - type: code
    content: |-
      radioInput(
        id = "radio1",
        choices = c(
          "Vehicula adipiscing mattis",
          "Magna nullam",
          "Aenean venenatis",
          "Tristique quam porta"
        )
      )
    output: |-
      <div class="yonder-radio" id="radio1">
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-371-496" name="radio1" value="Vehicula adipiscing mattis"/>
          <label class="custom-control-label" for="radio-371-496">Vehicula adipiscing mattis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-644-937" name="radio1" value="Magna nullam"/>
          <label class="custom-control-label" for="radio-644-937">Magna nullam</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-758-74" name="radio1" value="Aenean venenatis"/>
          <label class="custom-control-label" for="radio-758-74">Aenean venenatis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-417-408" name="radio1" value="Tristique quam porta"/>
          <label class="custom-control-label" for="radio-417-408">Tristique quam porta</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
- title: Inline radio input
  body:
  - type: code
    content: |-
      radioInput(
        id = "radio2",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        ),
        inline = TRUE  # <-
      )
    output: |-
      <div class="yonder-radio" id="radio2">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-267-532" name="radio2" value="Choice 1"/>
          <label class="custom-control-label" for="radio-267-532">Choice 1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-930-571" name="radio2" value="Choice 2"/>
          <label class="custom-control-label" for="radio-930-571">Choice 2</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-379-296" name="radio2" value="Choice 3"/>
          <label class="custom-control-label" for="radio-379-296">Choice 3</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
- title: Radiobars in comparison
  body:
  - type: code
    content: |-
      radiobarInput(
        id = "radiobar1",
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
      <div class="yonder-radiobar btn-group btn-group-toggle d-flex" id="radiobar1" data-toggle="buttons">
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="fusce sagittis" autocomplete="false"/>
          fusce sagittis
        </label>
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="libero non molestie" autocomplete="false"/>
          libero non molestie
        </label>
        <label class="btn btn-grey">
          <input name="radiobar1" type="radio" value="magna orci" autocomplete="false"/>
          magna orci
        </label>
        <label class="btn active btn-grey">
          <input name="radiobar1" type="radio" value="ultrices dolor" autocomplete="false" checked/>
          ultrices dolor
        </label>
      </div>
rdname: radioInput
sections: []
layout: doc
---
