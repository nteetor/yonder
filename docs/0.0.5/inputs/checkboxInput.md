---
this: checkboxInput
filename: R/checkbox.R
layout: page
roxygen:
  title: Checkbox inputs
  description: |-
    A reactive checkbox input. When a checkbox input is unchecked the reactive
    value is `NULL`. When checked the checkbox input reactive value is `value`.
    Unlike shiny, yonder's checkbox inputs are a singleton value.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the checkbox input, the
      reactive value of the checkbox input is available to the shiny server
      function as part of the `input` object.
  - name: choice
    description: A character string specifying a label for the checkbox.
  - name: value
    description: |-
      A character string, object to coerce to a character string, or
      `NULL` specifying the value of the checkbox or a new value for the
      checkbox, defaults to `choice`.
  - name: checked
    description: |-
      If `TRUE` the checkbox renders in a checked state, defaults
      to `FALSE`.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - title: Start checked
    source: |-
      checkboxInput(
        id = NULL,
        choice = "Suspendisse potenti",
        checked = TRUE
      )
    output:
    - |-
      <div class="yonder-checkbox">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-934-607" data-value="Suspendisse potenti" checked/>
          <label class="custom-control-label" for="checkbox-934-607">Suspendisse potenti</label>
          <div class="invalid-feedback"></div>
          <div class="valid-feedback"></div>
        </div>
      </div>
---
