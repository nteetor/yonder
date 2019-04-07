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
- name: stretch
  description: |-
    One of `TRUE` or `FALSE` specifying stretched behaviour for
    the button or link input, defaults to `FALSE`. If `TRUE`, the button or
    link will receive clicks from its containing block element. For example, a
    stretched button or link inside a [card()](content/card.html) would update whenever the user
    clicked on the card.
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
      id="button1" autocomplete="off">Simple</button>
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
      id="button2" autocomplete="off">Full-width</button>
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
      role="button" id="button3" autocomplete="off">Full and back again</button>
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
        <button class="yonder-button btn btn-red m-2" type="button" role="button" id="red" autocomplete="off">red</button>
        <button class="yonder-button btn btn-purple m-2" type="button" role="button" id="purple" autocomplete="off">purple</button>
        <button class="yonder-button btn btn-indigo m-2" type="button" role="button" id="indigo" autocomplete="off">indigo</button>
        <button class="yonder-button btn btn-blue m-2" type="button" role="button" id="blue" autocomplete="off">blue</button>
        <button class="yonder-button btn btn-cyan m-2" type="button" role="button" id="cyan" autocomplete="off">cyan</button>
        <button class="yonder-button btn btn-teal m-2" type="button" role="button" id="teal" autocomplete="off">teal</button>
        <button class="yonder-button btn btn-green m-2" type="button" role="button" id="green" autocomplete="off">green</button>
        <button class="yonder-button btn btn-yellow m-2" type="button" role="button" id="yellow" autocomplete="off">yellow</button>
        <button class="yonder-button btn btn-amber m-2" type="button" role="button" id="amber" autocomplete="off">amber</button>
        <button class="yonder-button btn btn-orange m-2" type="button" role="button" id="orange" autocomplete="off">orange</button>
        <button class="yonder-button btn btn-grey m-2" type="button" role="button" id="grey" autocomplete="off">grey</button>
      </div>
- title: Reactive links
  body:
  - type: code
    content: div("Curabitur ", linkInput("link1", "vulputate"), " vestibulum lorem.")
    output: "<div>\n  Curabitur \n  <button class=\"yonder-link btn btn-link\" id=\"link1\">vulputate</button>\n
      \  vestibulum lorem.\n</div>"
- title: Stretched buttons and links
  body:
  - type: code
    content: |-
      card(
        header = "Card with stretched button",
        p("Notice when you hover over the card, the button also detects ",
          "the hover."),
        buttonInput(
          id = "go",
          label = "Go go go",
          stretch = TRUE
        ) %>%
          background("blue")
      ) %>%
        width(20)
    output: "<div class=\"card w-20\">\n  <div class=\"card-header\">Card with stretched
      button</div>\n  <div class=\"card-body\">\n    <p>\n      Notice when you hover
      over the card, the button also detects \n      the hover.\n    </p>\n    <button
      class=\"yonder-button btn stretched-link btn-blue\" type=\"button\" role=\"button\"
      id=\"go\" autocomplete=\"off\">Go go go</button>\n  </div>\n</div>"
rdname: buttonInput
sections: []
layout: doc
---
