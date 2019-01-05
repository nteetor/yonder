---
name: disableInput
title: Enable, disable input
description: Prevent interacting with input choices.
parameters:
- name: id
  description: A character string specifying the reactive id of an input.
- name: values
  description: A vector specifying values to enable or disable.
- name: invert
  description: |-
    One of `TRUE` or `FALSE`, if `TRUE` choices which do _not_ have
    a matching value are enabled or disabled, defaults to `FALSE`.
- name: reset
  description: |-
    One of `TRUE` or `FALSE`, if `TRUE` choices are all enabled
    prior to disabling choices, defaults to `FALSE`.
- name: session
  description: A reactive context, defaults to \code{\link[=getDefaultReactiveDomain]{getDefaultReactiveDomain()}}.
export: ''
rdname: disableInput
sections: []
layout: doc
---
