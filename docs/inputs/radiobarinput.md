---
name: radiobarInput
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
          <input class="custom-control-input" type="radio" id="radio-252-963" name="radio1" value="Vehicula adipiscing mattis"/>
          <label class="custom-control-label" for="radio-252-963">Vehicula adipiscing mattis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-988-359" name="radio1" value="Magna nullam"/>
          <label class="custom-control-label" for="radio-988-359">Magna nullam</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-401-271" name="radio1" value="Aenean venenatis"/>
          <label class="custom-control-label" for="radio-401-271">Aenean venenatis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-910-226" name="radio1" value="Tristique quam porta"/>
          <label class="custom-control-label" for="radio-910-226">Tristique quam porta</label>
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
          <input class="custom-control-input" type="radio" id="radio-183-897" name="radio2" value="Choice 1"/>
          <label class="custom-control-label" for="radio-183-897">Choice 1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-915-514" name="radio2" value="Choice 2"/>
          <label class="custom-control-label" for="radio-915-514">Choice 2</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-221-541" name="radio2" value="Choice 3"/>
          <label class="custom-control-label" for="radio-221-541">Choice 3</label>
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
rdname: radiobarInput
sections: []
layout: doc
---
