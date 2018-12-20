---
name: index
title: Inputs
description: |-
  Yonder provides many familiar inputs like [selectInput()] or [radioInput()].
  There are also new inputs like [groupInput()] or [formInput()].
sections:
- title: Changes to be mindful of
  body: |-
    * Input functions have an `id` argument instead of `inputId`.

    * Inputs do not include a `label` argument to add a text label. To add a
      label to an input please use [formGroup()].

      [menuInput()] is an exception and does include a `label` argument. This
      argument controls the label or text of the menu trigger button.

    * `shiny::sliderInput()` has been split into three inputs: [rangeInput()],
      [intervalInput()], and [sliderInput()].
- title: Familiar variants
  body: |-
    Looking for ...

    * `radioButtons()` use [radioInput()]

    * `checkboxGroupInput()` use [checkbarInput()]

    * `numericInput()` use [numberInput()]

    * `submitButton()` use [submitInput()]

    * `updateRadioButtons()` or `updateTextInput()` use [updateChoices()] or
      [updateValues()]
noRd: ''
family: inputs
layout: doc
---
