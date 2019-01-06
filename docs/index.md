---
name: _PACKAGE
title: A new approach to shiny applications
description: Yonder is a set of tools for flexible and creative shiny application
  design.
sections:
- title: Inputs
  body: |-
    Yonder provides many familiar inputs like [selectInput()](yonder/inputs/selectInput.html) or [radioInput()](yonder/inputs/radioInput.html).
    There are also new inputs like [groupInput()](yonder/inputs/groupInput.html) or [formInput()](yonder/inputs/formInput.html).

    **Changes to be mindful of**

    * Input functions have an `id` argument instead of `inputId`.

    * Input functions do not include a `label` argument for the purpose of adding
      a label above the input. Button and menu inputs do include a `label`
      argument, but these arguments refer to button labels. If you would like to
      add a label above an input please use [formGroup()](yonder/layout/formGroup.html).

    * `shiny::sliderInput()` has been split into three inputs: [rangeInput()](yonder/inputs/rangeInput.html),
      [intervalInput()](yonder/inputs/intervalInput.html), and [sliderInput()](yonder/inputs/sliderInput.html).

    **Familiar variants**

    Looking for ... ?

    * `radioButtons()` use [radioInput()](yonder/inputs/radioInput.html)

    * `checkboxGroupInput()` use [checkbarInput()](yonder/inputs/checkbarInput.html)

    * `numericInput()` use [numberInput()](yonder/inputs/numberInput.html)

    * `submitButton()` use [submitInput()](yonder/inputs/submitInput.html)

    * `updateRadioButtons()`, `updateTextInput()`, etc. use [updateInput()](yonder/utilities/updateInput.html)
- title: Layout
  body: |-
    Included are a handful of tools for building applications for devices and
    screens of varying sizes. For real control over spacing elements be sure to
    check out [flex()](yonder/layout/flex.html), which gives you the power of flexbox layout.

    **Familiar variants**

    Looking for ... ?

    * `fluidRow()` use [row()](yonder/layout/row.html)

    * `fixedPage()`, `fluidPage()`, or `sidebarLayout()` use [container()](yonder/layout/container.html),
      [row()](yonder/layout/row.html), and [column()](yonder/layout/column.html)

    * `navbarPage()` use [navbar()](yonder/layout/navbar.html)
rdname: _PACKAGE
parameters: []
layout: doc
---
