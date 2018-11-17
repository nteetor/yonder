---
this: checkbarInput
filename: R/checkbox.R
layout: page
requires: ~
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
  - name: value,values
    description: |-
      A character string or vector specifying values for the
      checkbox or checkbar input, defaults to `choice` or `values`, respectively.
  - name: checked
    description: |-
      If `TRUE` the checkbox renders in a checked state, defaults
      to `FALSE`.
  - name: selected
    description: |-
      One of `values` specifying the initial value of the checkbar
      input, defaults to `NULL`, in which case no choice is selected.
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
        id = "potenti",
        choice = "Suspendisse potenti",
        checked = TRUE
      )
  - type: output
    value: |-
      <div class="yonder-checkbox" id="potenti">
        <div class="custom-control custom-checkbox">
          <input class="custom-control-input" type="checkbox" id="checkbox-890-730" data-value="Suspendisse potenti" checked/>
          <label class="custom-control-label" for="checkbox-890-730">Suspendisse potenti</label>
          <div class="invalid-feedback"></div>
          <div class="valid-feedback"></div>
        </div>
      </div>
  - type: markdown
    value: |
      <h3>Checkbar, checkbox group</h3>
  - type: source
    value: |2-

      checkbarInput(
        id = "checks",
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
      <div class="yonder-checkbar btn-group btn-group-toggle m-2" data-toggle="buttons" id="checks">
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
  - type: markdown
    value: |
      <h3>Labeling a checkbar</h3>
  - type: source
    value: |2-

      formGroup(
        label = "Toppings",
        checkbarInput(
          id = "fixins",
          choices = c(
            "Sprinkles",
            "Nuts",
            "Fudge"
          )
        )
      )
  - type: output
    value: |-
      <div class="form-group">
        <label>Toppings</label>
        <div class="yonder-checkbar btn-group btn-group-toggle" data-toggle="buttons" id="fixins">
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" data-value="Sprinkles"/>
            <span>Sprinkles</span>
          </label>
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" data-value="Nuts"/>
            <span>Nuts</span>
          </label>
          <label class="btn btn-grey">
            <input type="checkbox" autocomplete="off" data-value="Fudge"/>
            <span>Fudge</span>
          </label>
        </div>
      </div>
---
