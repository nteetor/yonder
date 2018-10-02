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
      * Included input functions have an `id` argument instead of `inputId`.

        A `NULL` value may be used to add an input element without binding it, i.e.
        a value is not passed back to the shiny server.

      * Inputs do not include a `label` argument. To add a label to an input please
        use [formGroup()](/yonder/0.0.5/layout/formGroup.html).
  return: ~
  family: inputs
  name: index
  rdname: ~
  examples: ~
---
