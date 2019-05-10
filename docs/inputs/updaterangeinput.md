---
name: updateRangeInput
title: Simple range input
description: '`rangeInput()` creates a simple numeric range input.'
inheritParams: checkboxInput
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
    A number between `min` and `max` specifying the default value
    of the input, defaults to `min`.
- name: step
  description: |-
    A number specifying the interval step of the input, defaults to
    `1`.
- name: value
  description: |-
    A number specifying a new value for the input, defaults to
    `NULL`.
details: |-
  The sophistication of this input will improve as browsers adopt the latest
  HTML standards.
family: inputs
export: ''
examples:
- title: Range inputs
  body:
  - type: text
    content: Select from a range of numeric values.
    output: ~
  - type: code
    content: rangeInput(id = "range1")
    output: |-
      <div class="yonder-range" id="range1">
        <input class="custom-range" type="range" step="1" min="0" max="100" value="0" autocomplete="off"/>
      </div>
rdname: updateRangeInput
sections: []
layout: doc
---
