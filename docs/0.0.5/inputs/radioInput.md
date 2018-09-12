---
this: radioInput
filename: R/radio.R
layout: page
roxygen:
  title: Radio inputs
  description: Create a reactive radio input of one or more radio controls.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of the radio input, the
      reactive value of the radio input is available to the shiny server
      function as part of the `input` object.
  - name: choices
    description: |-
      A character vector specifying labels for the radio input's
      choices.
  - name: values
    description: |-
      A character vector, list of character strings, vector of values
      to coerce to character strings, or list of values to coerce to character
      strings specifying the values of the radio input's choices, defaults to
      `choices`.
  - name: selected
    description: |-
      One of `values` indicating the default selected value of the
      radio input, defaults to `NULL`, in which case the first choice is
      selected by default.
  - name: help
    description: |-
      A character string specifying a small help label which appears
      below the input, defaults to `NULL` in which case help text is not added.
  - name: inline
    description: |-
      If `TRUE`, the radio input renders inline, defaults to `FALSE`,
      in which case the radio controls render on separate lines.
  - name: disabled
    description: |-
      One or more of `values` indicating which radio choices to
      disable, defaults to `NULL`, in which case all choices are enabled.
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
  - type: markdown
    value: |
      <h3>Stacked radio input</h3>
  - type: source
    value: |2-

      radioInput(
        id = "radio",
        choices = c(
          "Vehicula adipiscing mattis",
          "Magna nullam",
          "Aenean venenatis",
          "Tristique quam porta"
        )
      )
  - type: output
    value: |-
      <div class="yonder-radio" id="radio">
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-506-298" name="radio" data-value="Vehicula adipiscing mattis" checked/>
          <label class="custom-control-label" for="radio-506-298">Vehicula adipiscing mattis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-275-213" name="radio" data-value="Magna nullam"/>
          <label class="custom-control-label" for="radio-275-213">Magna nullam</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-95-329" name="radio" data-value="Aenean venenatis"/>
          <label class="custom-control-label" for="radio-95-329">Aenean venenatis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-761-571" name="radio" data-value="Tristique quam porta"/>
          <label class="custom-control-label" for="radio-761-571">Tristique quam porta</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Inline radio input</h3>
  - type: source
    value: |2-

      radioInput(
        id = "radio",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        ),
        inline = TRUE
      )
  - type: output
    value: |-
      <div class="yonder-radio" id="radio">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-426-50" name="radio" data-value="Choice 1" checked/>
          <label class="custom-control-label" for="radio-426-50">Choice 1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-282-829" name="radio" data-value="Choice 2"/>
          <label class="custom-control-label" for="radio-282-829">Choice 2</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-659-770" name="radio" data-value="Choice 3"/>
          <label class="custom-control-label" for="radio-659-770">Choice 3</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
---
