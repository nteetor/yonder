---
this: index
filename: R/yonder.R
layout: index
roxygen:
  title: Inputs
  description: |-
    Yonder provides many familiar inputs like [selectInput()](/yonder/0.0.5/inputs/selectInput.html) or [radioInput()](/yonder/0.0.5/inputs/radioInput.html).
    There are also new inputs like [groupInput()](/yonder/0.0.5/inputs/groupInput.html) or [formInput()](/yonder/0.0.5/inputs/formInput.html).
  parameters: []
  sections:
  - title: Changes to be mindful of
    body: |-
      * Input functions have an `id` argument instead of `inputId`.

      * Inputs do not include a `label` argument to add a text label. To add a
        label to an input please use [formGroup()](/yonder/0.0.5/layout/formGroup.html).

      * `shiny::sliderInput()` has been split into three inputs: [rangeInput()](/yonder/0.0.5/inputs/rangeInput.html),
        [intervalInput()](/yonder/0.0.5/inputs/intervalInput.html), and [sliderInput()](/yonder/0.0.5/inputs/sliderInput.html).
  - title: Familiar variants
    body: |-
      Looking for ...

      * `radioButtons()` use [radioInput()](/yonder/0.0.5/inputs/radioInput.html)

      * `checkboxGroupInput()` use [checkbarInput()](/yonder/0.0.5/inputs/checkbarInput.html)

      * `numericInput()` use [numberInput()](/yonder/0.0.5/inputs/numberInput.html)

      * `submitButton()` use [submitInput()](/yonder/0.0.5/inputs/submitInput.html)

      * `updateRadioButtons()` or `updateTextInput()` use [updateChoices()](/yonder/0.0.5/utilities/updateChoices.html) or
        [updateValues()](/yonder/0.0.5/utilities/updateValues.html)
  return: ~
  family: inputs
  name: index
  rdname: ~
  examples: ~
---
