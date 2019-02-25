---
name: linkInput
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
  description: A character string specifying the id of the reactive input.
- name: label
  description: |-
    A character string specifying the label text on the button
    input.
- name: value
  description: |-
    A character string specifying the value of a submit input,
    defaults to `label`. This value is used to distinguish form submission
    types in the case where a form input has multiple submit inputs.
- name: fill
  description: |-
    One of `TRUE` or `FALSE` specifying if the button fills the
    entire width of its parent, defaults to `FALSE`.
- name: text
  description: |-
    A character string specifying the text displayed as part of the
    link input.
- name: '...'
  description: |-
    Additional named arguments passed as HTML attributes to the parent
    element.
family: inputs
export: ''
examples:
- title: A simple button
  body:
  - type: code
    content: |-
      buttonInput(
        id = "button1",
        label = "Simple"
      )
    output: <button class="yonder-button btn btn-grey" type="button" role="button"
      id="button1">Simple</button>
  - type: text
    content: Alternatively, a button can fill the width of its parent element.
    output: ~
  - type: code
    content: |-
      buttonInput(
        id = "button2",
        label = "Full-width",
        fill = TRUE  # <-
      ) %>%
        background("red")
    output: <button class="yonder-button btn btn-block btn-red" type="button" role="button"
      id="button2">Full-width</button>
  - type: text
    content: Use design utilities to further adjust the width of a button.
    output: ~
  - type: code
    content: |-
      buttonInput(
        id = "button3",
        label = "Full and back again",
        fill = TRUE  # <-
      ) %>%
        background("red") %>%
        width("3/4")  # <-
    output: <button class="yonder-button btn btn-block btn-red w-3/4" type="button"
      role="button" id="button3">Full and back again</button>
- title: A submit button
  body:
  - type: code
    content: submitInput()
    output: <button class="yonder-submit btn btn-blue" role="button" value="Submit">Submit</button>
  - type: text
    content: Or use custom text to clarify the action taken when clicked by the user.
    output: ~
  - type: code
    content: submitInput("Place order")
    output: <button class="yonder-submit btn btn-blue" role="button" value="Place
      order">Place order</button>
- title: Possible colors
  body:
  - type: code
    content: |-
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey"
      )

      lapply(
        colors,
        function(color) {
          buttonInput(
            id = color,
            label = color
          ) %>%
            background(color) %>%
            margin(2)
        }
      ) %>%
        div() %>%
        display("flex") %>%
        flex(wrap = TRUE)
    output: |-
      <div class="d-flex flex-wrap">
        <button class="yonder-button btn btn-red m-2" type="button" role="button" id="red">red</button>
        <button class="yonder-button btn btn-purple m-2" type="button" role="button" id="purple">purple</button>
        <button class="yonder-button btn btn-indigo m-2" type="button" role="button" id="indigo">indigo</button>
        <button class="yonder-button btn btn-blue m-2" type="button" role="button" id="blue">blue</button>
        <button class="yonder-button btn btn-cyan m-2" type="button" role="button" id="cyan">cyan</button>
        <button class="yonder-button btn btn-teal m-2" type="button" role="button" id="teal">teal</button>
        <button class="yonder-button btn btn-green m-2" type="button" role="button" id="green">green</button>
        <button class="yonder-button btn btn-yellow m-2" type="button" role="button" id="yellow">yellow</button>
        <button class="yonder-button btn btn-amber m-2" type="button" role="button" id="amber">amber</button>
        <button class="yonder-button btn btn-orange m-2" type="button" role="button" id="orange">orange</button>
        <button class="yonder-button btn btn-grey m-2" type="button" role="button" id="grey">grey</button>
      </div>
- title: Reactive links
  body:
  - type: code
    content: div("Curabitur ", linkInput("link1", "vulputate"), " vestibulum lorem.")
    output: "<div>\n  Curabitur \n  <button class=\"yonder-link btn btn-link\" id=\"link1\">vulputate</button>\n
      \  vestibulum lorem.\n</div>"
rdname: linkInput
sections: []
layout: doc
---
