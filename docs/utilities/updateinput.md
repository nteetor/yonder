---
name: updateInput
title: Update input choices and values
description: |-
  Use `updateInput()` to replace an input's choices and values. Optionally,
  a new choices may be selected.
parameters:
- name: id
  description: A character string specifying the id of an input.
- name: choices
  description: |-
    A character vector or list of tag elements specifying new
    choices for the input.
- name: values
  description: An atomic vector specifying new values for the input.
- name: selected
  description: |-
    One of `values` specifying which choice to select, defaults
    to `NULL`, in which case a choice is not selected. Note that browsers may
    automatically select a choice if not specified.
- name: session
  description: A reactive context, defaults to [getDefaultReactiveDomain()](getdefaultreactivedomain.html).
sections:
- title: Button inputs
  body: |-
    When updating a button input if `values` equals `choices`, the default value
    for `values`, the value of the button input is left as is.

    Passing a non-numeric value will reset the button input's value.
- title: File inputs
  body: Files inputs do not currently support `updateInput()`.
- title: Form inputs
  body: |-
    Form inputs do not support `updateInput()`, instead update the specific
    inputs within the form.
family: utilities
export: ''
rdname: updateInput
layout: doc
---
