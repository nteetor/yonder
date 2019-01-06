---
name: updateInput
title: Update input
description: |-
  Modify an input's choices, values, or selected choices. Importantly, an
  input's choices and selected choices are updated after any values are
  updated. Thus, `choices` and `selected` must refer to the new, updated
  values.
parameters:
- name: id
  description: A character string specifying the reactive id of an input.
- name: choices
  description: |-
    A character vector, tag element, or list specifying choices
      for the input.

      If `choices` is an **unnamed** vector, list, or element then the input's
      choices are updated sequentially.

      If `choices` is a **named** vector or list then the input's choices are
      matched by value. The names of `choices` refer to one or more possible
      values of the input and the values of `choices` are the new choice labels.
- name: values
  description: |-
    An atomic vector or list of atomic singleton values, values
      will be coerced to character strings.

      If `values` is an **unnamed** vector or list then the input's values are
      updated sequentially.
- name: selected
  description: |-
    One of `values` specifying which choice to select, defaults
    to `NULL`, in which case a choice is not selected. Note that browsers may
    automatically select a choice if not specified.
- name: session
  description: A reactive context, defaults to \code{\link[=getDefaultReactiveDomain]{getDefaultReactiveDomain()}}.
details: |-
  If specifying new values with `values`, both `choices` and `selected` need to
  refer to these new values.
family: utilities
export: ''
rdname: updateInput
sections: []
layout: doc
---
