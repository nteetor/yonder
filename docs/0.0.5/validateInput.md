---
this: validateInput
filename: R/inputs.R
layout: page
requires: ~
roxygen:
  title: Validate, invalidate input
  description: |-
    `invalidateInput()` and `validateInput()` are new utilities for conveying
    information to users. `invalidateInput()` adds text to an input letting a
    user know why an input is valid or invalid. Additionally, `invalidateInput()`
    will immediately freeze an input. As a result, further observers or reactives
    using the input are not triggered. `validateInput()` will immediately thaw
    the reactive input, thus allowing subsequent observers and reactives to
    trigger.
  parameters:
  - name: id
    description: A character string specifying the reactive id of an input.
  - name: message
    description: A character string specifying the message.
  sections: []
  return: ~
  family: ~
  name: ~
  rdname: ~
  examples: ~
---
