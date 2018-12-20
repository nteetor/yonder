---
name: buttonInput
title: Button and submit inputs
description: |-
  Button inputs are useful as triggers for reactive or observer expressions.
  The reactive value of a button input begins as `NULL`, but subsequently is
  the number of clicks.

  A submit input is a special type of button used to control form input
  submission. Because of their specific usage, submit inputs do not require an
  `id`, but may have a specified `value`. Submit inputs will _not_ freeze all
  reactive inputs, see [formInput()].
parameters:
- name: id
  description: A character string specifying the reactive id of the input.
- name: '...'
  description: Additional named arguments passed as HTML attributes to the parent
    element.
- name: label
  description: |-
    A character string specifying the label text on the button
    input.
- name: value
  description: |-
    A character string specifying the value of a submit input,
    defaults to `label`. This value is used to distinguish form submission
    types in the case where a form input has multiple submit inputs.
- name: block
  description: |-
    If `TRUE`, the input is block-level instead of inline, defaults
    to `FALSE`. A block-level element will occupy the entire width of its
    parent element.
- name: text
  description: |-
    A character string specifying the text displayed as part of the
    link input.
family: inputs
export: ''
examples:
- title: |-
    buttonInput(
      id = NULL,
      label = "Simple"
    )
  body: []
- title: Block buttons will fill the width of their parent element
  body:
  - code: |-
      buttonInput(
        id = NULL,
        label = "Block",
        block = TRUE
      ) %>%
        background("red")
    output: <button class="yonder-button btn btn-block btn-red" type="button" role="button">Block</button>
- title: '## A submit button'
  body:
  - code: submitInput()
    output: <button class="yonder-submit btn btn-blue" role="button" value="Submit">Submit</button>
- title: Or use custom text to clarify the action taken when clicked by the user.
  body:
  - code: submitInput("Place order")
    output: <button class="yonder-submit btn btn-blue" role="button" value="Place
      order">Place order</button>
- title: '## Possible colors'
  body:
  - code: |-
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey"
      )

      div(
        lapply(
          colors,
          function(color) {
            buttonInput(
              id = NULL,
              label = color
            ) %>%
              background(color) %>%
              margin(2)
          }
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <button class="yonder-button btn btn-red m-2" type="button" role="button">red</button>
        <button class="yonder-button btn btn-purple m-2" type="button" role="button">purple</button>
        <button class="yonder-button btn btn-indigo m-2" type="button" role="button">indigo</button>
        <button class="yonder-button btn btn-blue m-2" type="button" role="button">blue</button>
        <button class="yonder-button btn btn-cyan m-2" type="button" role="button">cyan</button>
        <button class="yonder-button btn btn-teal m-2" type="button" role="button">teal</button>
        <button class="yonder-button btn btn-green m-2" type="button" role="button">green</button>
        <button class="yonder-button btn btn-yellow m-2" type="button" role="button">yellow</button>
        <button class="yonder-button btn btn-amber m-2" type="button" role="button">amber</button>
        <button class="yonder-button btn btn-orange m-2" type="button" role="button">orange</button>
        <button class="yonder-button btn btn-grey m-2" type="button" role="button">grey</button>
      </div>
- title: '## Reactive links'
  body:
  - code: div("Curabitur ", linkInput("inline", "vulputate"), " vestibulum lorem.")
    output: "<div>\n  Curabitur \n  <button class=\"yonder-link btn btn-link\" id=\"inline\">vulputate</button>\n
      \  vestibulum lorem.\n</div>"
layout: doc
---
