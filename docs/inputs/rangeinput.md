---
name: rangeInput
title: Inputs for numeric ranges
description: |-
  Use `rangeInput()` and `intervalInput()` to allow users to select from a
  range of numeric values. For a slider input with non-numeric values refer to
  [sliderInput()].
inheritParams: buttonInput
parameters:
- name: min
  description: |-
    A number specifying the minimum value of the input, defaults to
    `0`.
- name: max
  description: |-
    A number specifying the maximum value of the input, defaults to
    `100`.
- name: default
  description: |-
    A numeric vector between `min` and `max` specifying the
      default value of the input.

      For **rangeInput()**, a single number, defaults to `min`.

      For **intervalInput()**, a vector of two numbers, defaults to
      `c(min, max)`.
- name: step
  description: |-
    A number specifying the interval step of the input, defaults to
    `1`.
- name: draggable
  description: |-
    One of `TRUE` or `FALSE` specifying if the user can drag the
    interval between an interval input's two sliders, defaults to `FALSE`. If
    `TRUE`, the slider interval may be dragged with the cursor.
- name: ticks
  description: |-
    One of `TRUE` or `FALSE` specifying if tick marks are added to
    the input, defaults to `TRUE`.
- name: fill
  description: |-
    One of `TRUE` or `FALSE` specifying whether the filled portion of
    a range or slider input is shown, defaults to `TRUE`.
- name: labels
  description: |-
    One of `TRUE`, `FALSE`, or a number specifying how labels are
      applied to tick marks.

      If **numeric**, `labels` specifies the exact number of
      tick mark labels added to the input.

      If **`TRUE`**, labels are added to the tick marks and the number of labels
      is determined by `step`.

      If **`FALSE`**, labels are not added to the tick marks.
- name: prefix
  description: |-
    A character string specifying a prefix for the input value,
    defaults to `NULL`, in which case a prefix is not prepended.
- name: suffix
  description: |-
    A character string specifying a suffix for the input value,
    defaults to `NULL`, in which case a prefix is not appended.
family: inputs
export: ''
examples:
- title: Range inputs
  body:
  - type: literal
    content: <script> $(function() {   $(".yonder-range").each(function() {     $(this.querySelector("input")).ionRangeSlider();   });
      }); </script>
    output: ~
  - type: text
    content: Select from a range of numeric values.
    output: ~
  - type: code
    content: |-
      rangeInput(id = "range1") %>%
        background("yellow")
    output: |-
      <div class="yonder-range range-yellow" id="range1">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="1" data-from="0" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
      </div>
- title: Increase the number of labels
  body:
  - type: code
    content: |-
      rangeInput(
        id = "range2",
        default = 30,
        labels = 8
      ) %>%
        background("purple")
    output: |-
      <div class="yonder-range range-purple" id="range2">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="1" data-from="30" data-prettify-separator="," data-grid="TRUE" data-grid-num="8"/>
      </div>
- title: Increase thumb step
  body:
  - type: text
    content: We'll hide the filled portion of the input with `fill` and change how
      tick marks are placed with `snap`.
    output: ~
  - type: code
    content: |-
      rangeInput(
        id = "range3",
        step = 10,  # <-
        snap = TRUE,
        fill = FALSE
      ) %>%
        background("red")
    output: |-
      <div class="yonder-range range-no-fill range-red" id="range3" snap="TRUE">
        <input class="range" type="text" data-type="single" data-min="0" data-max="100" data-step="10" data-from="0" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
      </div>
- title: Interval inputs
  body:
  - type: text
    content: Select an interval from a range of numeric values. Intervals are draggable
      by default, this can be toggled off with `draggable = FALSE`.
    output: ~
  - type: code
    content: |-
      intervalInput(
        id = "interval1",
        default = c(45, 65)
      ) %>%
        background("blue")
    output: |-
      <div class="yonder-range range-blue" id="interval1">
        <input class="range" type="text" data-type="double" data-min="0" data-max="100" data-from="45" data-to="65" data-drag-interval="FALSE" data-prettify-separator="," data-grid="TRUE" data-grid-num="4"/>
      </div>
rdname: rangeInput
sections: []
layout: doc
---
