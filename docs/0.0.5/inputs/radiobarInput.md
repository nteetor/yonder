---
this: radiobarInput
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
      A character vector specifying labels for the radio or radiobar
      input's choices.
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
  sections: []
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
        id = "stacked",
        choices = c(
          "Vehicula adipiscing mattis",
          "Magna nullam",
          "Aenean venenatis",
          "Tristique quam porta"
        )
      )
  - type: output
    value: |-
      <div class="yonder-radio" id="stacked">
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-914-749" name="stacked" data-value="Vehicula adipiscing mattis" checked/>
          <label class="custom-control-label" for="radio-914-749">Vehicula adipiscing mattis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-798-821" name="stacked" data-value="Magna nullam"/>
          <label class="custom-control-label" for="radio-798-821">Magna nullam</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-116-149" name="stacked" data-value="Aenean venenatis"/>
          <label class="custom-control-label" for="radio-116-149">Aenean venenatis</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" type="radio" id="radio-729-789" name="stacked" data-value="Tristique quam porta"/>
          <label class="custom-control-label" for="radio-729-789">Tristique quam porta</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Inline radio input</h3>
  - type: source
    value: |2-

      radioInput(
        id = "inline",
        choices = c(
          "Choice 1",
          "Choice 2",
          "Choice 3"
        ),
        inline = TRUE  # <-
      )
  - type: output
    value: |-
      <div class="yonder-radio" id="inline">
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-176-76" name="inline" data-value="Choice 1" checked/>
          <label class="custom-control-label" for="radio-176-76">Choice 1</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-208-453" name="inline" data-value="Choice 2"/>
          <label class="custom-control-label" for="radio-208-453">Choice 2</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" type="radio" id="radio-174-753" name="inline" data-value="Choice 3"/>
          <label class="custom-control-label" for="radio-174-753">Choice 3</label>
        </div>
        <div class="invalid-feedback"></div>
      </div>
  - type: markdown
    value: |
      <h3>Radiobars in comparison</h3>
  - type: source
    value: |2-

      radiobarInput(
        id = NULL,
        choices = c(
          "fusce sagittis",
          "libero non molestie",
          "magna orci",
          "ultrices dolor"
        ),
        selected = "ultrices dolor"
      ) %>%
        background("grey")
  - type: output
    value: |-
      <div class="yonder-radiobar btn-group btn-group-toggle" data-toggle="buttons">
        <label class="btn btn-grey">
          <input type="radio" data-value="fusce sagittis" autocomplete="false"/>
          <span>fusce sagittis</span>
        </label>
        <label class="btn btn-grey">
          <input type="radio" data-value="libero non molestie" autocomplete="false"/>
          <span>libero non molestie</span>
        </label>
        <label class="btn btn-grey">
          <input type="radio" data-value="magna orci" autocomplete="false"/>
          <span>magna orci</span>
        </label>
        <label class="btn active btn-grey">
          <input type="radio" data-value="ultrices dolor" autocomplete="false" checked/>
          <span>ultrices dolor</span>
        </label>
      </div>
---
