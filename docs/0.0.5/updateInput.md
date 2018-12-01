---
this: updateInput
filename: R/inputs.R
layout: page
requires: ~
roxygen:
  title: Update input
  description: Input utilities.
  parameters:
  - name: id
    description: A character string specifying the reactive id of an input.
  - name: choices
    description: |-
      A character vector, tag element, or list specifying choices
      for the input.
  - name: values
    description: |-
      An object specifying values for the input, this object is
      coerced to a character vector.
  - name: selected
    description: |-
      One of `values` specifying which choice to select, defaults
      to `NULL`, in which case a choice is not selected. Note that browsers may
      automatically select a choice if not specified.
  - name: session
    description: A reactive context, defaults to [getDefaultReactiveDomain()](/yonder/0.0.5/getDefaultReactiveDomain.html).
  sections:
  - title: Combinations of `choices` and `values`
    body: |-
      **choices** and **values** specified: the input's choices and values are
      updated.

      **choices** is specified and **values** is `NULL`: `values` defaults to
      `choices`.

      **choices** is `NULL` and **values** is specified: use this case for inputs
      without choices, e.g. a text input, to update only the current value.

      **choices** and **values** both `NULL`: used to preserve choices and values
      while changing the selected choice with `selected`.
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples: ~
---
