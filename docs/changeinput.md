---
name: changeInput
title: Change input selection
description: |-
  Use `changeInput()` to change an input's selected values. Values may be
  selected using regular expression pattern matching or exact matches, see
  `fixed`.
inheritParams: updateInput
parameters:
- name: pattern
  description: |-
    A character string specifying a regular expression, if `fixed`
    is `FALSE`, values which match the expression will be selected. If `fixed`
    is `TRUE`, a character vector of one or more values specifying exact values
    to select.
- name: fixed
  description: |-
    One of `TRUE` or `FALSE` specifying if `pattern` is interpreted
    as a regular expression or a vector of character literals, defaults to
    `FALSE`.
- name: invert
  description: |-
    One of `TRUE` or `FALSE` specifying how values are matched,
    if `TRUE` values which do _not_ match `pattern` will be selected, defaults
    to `FALSE`.
- name: reset
  description: |-
    One of `TRUE` or `FALSE` indicating how to handle any currently
    selected values, if `TRUE` the current selection is dropped before
    selecting new values, defaults to `TRUE`.
- name: propagate
  description: |-
    One of `TRUE` or `FALSE` specifying if the value change
    causes a re-evaluation of dependent reactives and observers, defaults to
    `FALSE`.
export: ''
rdname: changeInput
sections: []
layout: doc
---
