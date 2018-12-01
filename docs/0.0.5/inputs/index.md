---
this: index
filename: R/yonder.R
layout: index
requires: ~
roxygen:
  title: Inputs
  description: |-
    Yonder provides many familiar inputs like [selectInput()](/yonder/0.0.5/selectInput.html) or [radioInput()](/yonder/0.0.5/radioInput.html).
    There are also new inputs like [groupInput()](/yonder/0.0.5/groupInput.html) or [formInput()](/yonder/0.0.5/formInput.html).
  parameters: []
  sections:
  - title: Changes to be mindful of
    body: |-
      * Input functions have an `id` argument instead of `inputId`.

      * Inputs do not include a `label` argument to add a text label. To add a
        label to an input please use [formGroup()](/yonder/0.0.5/layout/formGroup.html).

        [menuInput()](/yonder/0.0.5/menuInput.html) is an exception and does include a `label` argument. This
        argument controls the label or text of the menu trigger button.

      * `shiny::sliderInput()` has been split into three inputs: [rangeInput()](/yonder/0.0.5/rangeInput.html),
        [intervalInput()](/yonder/0.0.5/intervalInput.html), and [sliderInput()](/yonder/0.0.5/sliderInput.html).
  - title: Familiar variants
    body: |-
      Looking for ...

      * `radioButtons()` use [radioInput()](/yonder/0.0.5/radioInput.html)

      * `checkboxGroupInput()` use [checkbarInput()](/yonder/0.0.5/checkbarInput.html)

      * `numericInput()` use [numberInput()](/yonder/0.0.5/numberInput.html)

      * `submitButton()` use [submitInput()](/yonder/0.0.5/submitInput.html)

      * `updateRadioButtons()` or `updateTextInput()` use [updateChoices()](/yonder/0.0.5/updateChoices.html) or
        [updateValues()](/yonder/0.0.5/updateValues.html)
  return: ~
  family: inputs
  name: index
  rdname: ~
  examples: ~
---
