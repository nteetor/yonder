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

      * `fluidRow()` use [row()](/yonder/0.0.5/layout/row.html)

      * `fixedPage()`, `fluidPage()` or `sidebarLayout()` use [container()](/yonder/0.0.5/layout/container.html),
        [row()](/yonder/0.0.5/layout/row.html), and [column()](/yonder/0.0.5/layout/column.html)

      * `withProgress()` use [progressOutlet()](/yonder/0.0.5/content/progressOutlet.html)

      * `checkboxGroupInput()` use [checkbarInput()](/yonder/0.0.5/inputs/checkbarInput.html)

      * `updateRadioButtons()` or `updateTextInput()` use [updateChoices()](/yonder/0.0.5/utilities/updateChoices.html) or
        [updateValues()](/yonder/0.0.5/utilities/updateValues.html)
  return: ~
  family: inputs
  name: index
  rdname: ~
  examples: ~
---
