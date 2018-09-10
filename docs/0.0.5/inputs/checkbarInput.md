---
this: checkbarInput
filename: R/bars.R
layout: page
roxygen:
  title: Checkbar and radiobar inputs
  description: |-
    These inputs behave similarly to their counter parts, checkbox and radio
    inputs. However, yonder's checkbox input is a singleton value, thus the
    checkbar input is more akin to shiny's checkbox group input.
  parameters:
  - name: id
    description: A character string specifying the id of the input.
  - name: choices
    description: |-
      A character vector or flat list of character strings
      specifying the labels of the checkbar or radiobar options.
  - name: values
    description: |-
      A character vector, flat list of character strings, or object
      to coerce to either, specifying the values of the checkbar or radiobar
      options, defaults to `choices`.
  - name: selected
    description: |-
      One or more of `values` indicating which of the checkbar or
      radiobar options are selected by default, defaults to `NULL`, in which case
      there is no default option.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>An alternative to checkbox groups</h2>
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
  - type: markdown
    value: |
      <h2>Radiobars in comparison</h2>
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
