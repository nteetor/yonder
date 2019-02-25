---
name: sliderInput
title: Slider with custom choices
description: |-
  A slider input with custom choices and values. Unlike [rangeInput()] or
  [intervalInput()] the slider input does range over a set of numeric values.
  Instead the slider input may be used similarly to a radio input.
inheritParams: buttonInput
parameters:
- name: choices
  description: A character vector specifying the slider labels.
- name: values
  description: |-
    A character vector specifying the values of the input,
    defaults to `choices`.
- name: selected
  description: |-
    One of `values` specifying the initial value of the slider
    input, defaults to `values[[1]]`.
- name: fill
  description: |-
    One of `TRUE` or `FALSE` specifying whether the filled portion of
    the slider input is shown, defaults to `FALSE`.
inheritParams: buttonInput
family: inputs
export: ''
examples:
- title: Custom chocies
  body:
  - type: literal
    content: <script> $(function() {   $(".yonder-range").each(function() {     $(this.querySelector("input")).ionRangeSlider();   });
      }); </script>
    output: ~
  - type: text
    content: Select a value from a set of choices using a slider.
    output: ~
  - type: code
    content: |-
      sliderInput(
        id = "slider1",
        choices = c("Closest", "Close", "Far", "Farthest")
      )
    output: |-
      <div class="yonder-range range-grey range-no-fill" id="slider1">
        <input class="range" type="text" data-type="single" data-values="Closest,Close,Far,Farthest" data-choices="Closest,Close,Far,Farthest" data-from="0" data-grid="TRUE" data-hide-min-max="TRUE"/>
      </div>
rdname: sliderInput
sections: []
layout: doc
---
