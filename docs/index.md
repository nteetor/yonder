---
name: _PACKAGE
title: A new approach to shiny applications
description: Yonder is a set of tools for flexible and creative shiny application
  design.
sections:
- title: Inputs
  body: |-
    Yonder provides many familiar inputs like [selectInput()](inputs/selectinput.html) or [radioInput()](inputs/radioinput.html).
    There are also new inputs like [groupInput()](inputs/groupinput.html) or [formInput()](inputs/forminput.html).

    **Changes to be mindful of**

    * Input functions have an `id` argument instead of `inputId`.

    * Input functions do not include a `label` argument for the purpose of adding
      a label above the input. Button and menu inputs do include a `label`
      argument, but these arguments refer to button labels. If you would like to
      add a label above an input please use [formGroup()](layout/formgroup.html).

    * `shiny::sliderInput()` has been split into three inputs: [rangeInput()](inputs/rangeinput.html),
      [intervalInput()](inputs/intervalinput.html), and [sliderInput()](inputs/sliderinput.html).

    **Familiar variants**

    Looking for ... ?

    * `radioButtons()` use [radioInput()](inputs/radioinput.html)

    * `checkboxGroupInput()` use [checkbarInput()](inputs/checkbarinput.html)

    * `numericInput()` use [numberInput()](inputs/numberinput.html)

    * `submitButton()` use [submitInput()](inputs/submitinput.html)

    * `updateRadioButtons()`, `updateTextInput()`, etc. use [updateInput()](utilities/updateinput.html)
- title: Layout
  body: |-
    Included are a handful of tools for building applications for devices and
    screens of varying sizes. For real control over spacing elements be sure to
    check out [flex()](layout/flex.html), which gives you the power of flexbox layout.

    **Familiar variants**

    Looking for ... ?

    * `fluidRow()` or `fixedRow()` use [columns()](layout/columns.html)

    * `fixedPage()`, `fluidPage()`, or `sidebarLayout()` use [container()](layout/container.html),
      [columns()](layout/columns.html), and [column()](layout/column.html)

    * `navbarPage()` use [navbar()](layout/navbar.html)
rdname: _PACKAGE
parameters: []
layout: doc
---
