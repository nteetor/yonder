---
this: sliderInput
filename: R/range.R
layout: page
requires: ~
roxygen:
  title: Ranges, intervals, and custom sliders
  description: A take on shiny's `sliderInput`.
  parameters:
  - name: id
    description: A character string specifying the id of the range input or `NULL`.
  - name: min
    description: |-
      A number specifying the minimum value of the range input, defaults
      to `0`.
  - name: max
    description: |-
      A number specifying the maximum value of the range input, defaults
      to `100`.
  - name: default
    description: |-
      A numeric vector between `min` and `max` specifying the
      default value of the range input.

      For **rangeInput**, a single number, defaults to `min`.

      For **intervalInput**, a vector of two numbers specifying the minimum and
      maximum of the slider interval, defaults to `c(min, max)`.
  - name: step
    description: |-
      A number specifying the interval step of the range input,
      defaults to `1`.
  - name: draggable
    description: |-
      One of `TRUE` or `FALSE` specifying if the user can drag the
      interval between an interval input's two sliders defaults to `FALSE`. If
      `TRUE` the slider interval may be dragged with the cursor, otherwise the
      interval is not draggable.
  - name: choices
    description: |-
      A character vector specifying the labels along the slider
      input.
  - name: values
    description: |-
      A character vector specifying the values of the slider input,
      defaults to `choices`.
  - name: selected
    description: |-
      One of `values` specifying the initial value of the slider
      input, defaults to `NULL`, in which case the slider input defaults to the
      first choice.
  - name: ticks
    description: |-
      One of `TRUE` or `FALSE` specifying if tick marks are added to
      the range input, defaults to `FALSE`. If `TRUE` tick marks are added,
      otherwise if `FALSE` tick marks are not added.
  - name: fill
    description: |-
      One of `TRUE` or `FALSE` specifying whether the filled portion of
      a range or slider input is shown. If `FALSE` the filled porition is hidden.

      For **rangeInput** the default is `TRUE`.

      For **sliderInput** the default is `FALSE`.
  - name: labels
    description: |-
      A number specifying how many ticks are labeled, defaults to
      `4`. If `snap` is `TRUE`, this argument is ignored and tick labels are
      based on `step`.
  - name: snap
    description: |-
      One of `TRUE` or `FALSE` specifying how the range input tick
      marks are labeled, defaults to `FALSE`. If `TRUE` the range input tick
      marks are adjusted to align with a multiple of `step`. If `FALSE` the range
      input tick marks are calculeted using `labels`.
  - name: prefix
    description: |-
      A character string specifying a prefix for the range input
      slider value, defaults to `NULL`, in which case a prefix is not prepended.
  - name: suffix
    description: |-
      A character string specifying a suffix for the range input
      slider value, defaults to `NULL`, in which case a prefix is not appended.
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
      <h3>Range inputs</h3>
  - type: markdown
    value: |
      <p>Select from a range of numeric values.</p>
  - type: source
    value: |2-

      rangeInput(id = NULL) %>%
        background("yellow")
  - type: output
    value: |-
      <div class="yonder-range bg-yellow">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="1" data-from="0" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
      </div>
  - type: markdown
    value: |
      <h3>Increase the number of labels</h3>
  - type: source
    value: |2-

      rangeInput(
        id = NULL,
        default = 30,
        labels = 8
      ) %>%
        background("purple")
  - type: output
    value: |-
      <div class="yonder-range bg-purple">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="1" data-from="30" data-prettify-separator="," data-grid="TRUE" data-grid-num="8"/>
      </div>
  - type: markdown
    value: |
      <h3>Increase thumb step</h3>
  - type: markdown
    value: |
      <p>We'll hide the filled portion of the input with <code>fill</code> and change how tick marks are placed with <code>snap</code>.</p>
  - type: source
    value: |2-

      rangeInput(
        id = NULL,
        step = 10,  # <-
        snap = TRUE,
        fill = FALSE
      ) %>%
        background("red")
  - type: output
    value: |-
      <div class="yonder-range bg-red">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="10" data-from="0" data-prettify-separator="," data-grid="TRUE" data-grid-num="4" data-grid-snap="TRUE" data-no-fill="true"/>
      </div>
  - type: markdown
    value: |
      <h3>Interval inputs</h3>
  - type: markdown
    value: |
      <p>Select an interval from a range of numeric values. Intervals are draggable by default, this can be toggled off with <code>draggable = FALSE</code>.</p>
  - type: source
    value: |2-

      intervalInput(
        id = NULL,
        default = c(45, 65)
      ) %>%
          background("blue")
  - type: output
    value: |-
      <div class="yonder-range bg-blue">
        <input class="range" type="text" data-type="double" data-min="0" data-max="100" data-from="45" data-to="65" data-drag-interval="FALSE" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
      </div>
  - type: markdown
    value: |
      <h3>sliderInput</h3>
  - type: markdown
    value: |
      <p>Select a value from a set of choices using a slider.</p>
  - type: source
    value: |2-

      sliderInput

      sliderInput(
        id = NULL,
        choices = paste("Choice", 1:6)
      )
  - type: output
    value: |-
      <div class="yonder-range bg-grey">
        <input class="range" type="text" data-type="single" data-values="Choice 1,Choice 2,Choice 3,Choice 4,Choice 5,Choice 6" data-choices="Choice 1,Choice 2,Choice 3,Choice 4,Choice 5,Choice 6" data-from data-grid="TRUE" data-hide-min-max="TRUE" data-no-fill="true"/>
      </div>
---
