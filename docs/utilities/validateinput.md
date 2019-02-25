---
name: validateInput
title: Validate, invalidate input
description: |-
  `invalidateInput()` and `validateInput()` are new utilities for conveying
  information to users. `invalidateInput()` adds text to an input letting a
  user know why an input is valid or invalid. Additionally, `invalidateInput()`
  will immediately freeze an input. As a result, further observers or reactives
  using the input are not triggered. `validateInput()` will immediately thaw
  the reactive input, thus allowing subsequent observers and reactives to
  trigger.
inheritParams: updateInput
parameters:
- name: message
  description: |-
    A character string specifying the message, default to `NULL`,
    in which case the input is highlighted, but no message is shown.
family: utilities
export: ''
rdname: validateInput
sections: []
layout: doc
---
