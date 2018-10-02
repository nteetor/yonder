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
  - name: choice,choices
    description: |-
      A character string or vector specifying a label for the
      checkbox or checkbar.
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
  sections: []
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Start checked</h3>
  - type: source
    value: |2-

      checkboxInput(
        id = NULL,
        choice = "Suspendisse potenti",
        checked = TRUE
      )
  - type: output
    value: |-
      <div class="yonder-checkbox">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-955-855" data-value="Suspendisse potenti" checked/>
          <label class="custom-control-label" for="checkbox-955-855">Suspendisse potenti</label>
          <div class="invalid-feedback"></div>
          <div class="valid-feedback"></div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>An alternative to checkbox groups</h3>
  - type: source
    value: |2-

      checkbarInput(
        id = NULL,
        choices = c(
          "Check 1",
          "Check 2",
          "Check 3"
        ),
        selected = "Check 1"
      ) %>%
        background("blue") %>%
        margin(2)
  - type: output
    value: |-
      <div class="yonder-checkbar btn-group btn-group-toggle m-2" data-toggle="buttons">
        <label class="btn active btn-blue">
          <input type="checkbox" autocomplete="off" data-value="Check 1" checked/>
          <span>Check 1</span>
        </label>
        <label class="btn btn-blue">
          <input type="checkbox" autocomplete="off" data-value="Check 2"/>
          <span>Check 2</span>
        </label>
        <label class="btn btn-blue">
          <input type="checkbox" autocomplete="off" data-value="Check 3"/>
          <span>Check 3</span>
        </label>
      </div>
---
