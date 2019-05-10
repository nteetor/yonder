---
name: checkbarInput
title: Checkbar input
description: A stylized checkbox input.
inheritParams: checkboxInput
parameters:
- name: choices
  description: |-
    A character vector or list of tag element specifying the
    input's choices, defaults to `NULL`.
- name: values
  description: |-
    A vector of values specifying the values of the input's
    choices, defaults to `choices`.
- name: selected
  description: |-
    One or more of `values` specifying the input's default
    selected values, defaults to `NULL`.
family: inputs
export: ''
examples:
- title: Default checkbar
  body:
  - type: code
    content: |-
      checkbarInput(
        id = "cb1",
        choices = c("When", "Why", "Where")
      )
    output: |-
      <div class="yonder-checkbar btn-group btn-group-toggle d-flex" id="cb1" data-toggle="buttons">
        <label class="btn btn-grey">
          <input type="checkbox" autocomplete="off" value="When"/>
          When
        </label>
        <label class="btn btn-grey">
          <input type="checkbox" autocomplete="off" value="Why"/>
          Why
        </label>
        <label class="btn btn-grey">
          <input type="checkbox" autocomplete="off" value="Where"/>
          Where
        </label>
      </div>
- title: Modifying background color
  body:
  - type: code
    content: |-
      checkbarInput(
        id = "cb2",
        choices = c("What", "Which")
      ) %>%
        background("teal")
    output: |-
      <div class="yonder-checkbar btn-group btn-group-toggle d-flex" id="cb2" data-toggle="buttons">
        <label class="btn btn-teal">
          <input type="checkbox" autocomplete="off" value="What"/>
          What
        </label>
        <label class="btn btn-teal">
          <input type="checkbox" autocomplete="off" value="Which"/>
          Which
        </label>
      </div>
rdname: checkbarInput
sections: []
layout: doc
---
