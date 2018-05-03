---
layout: page
slug: mark-invalid
roxygen:
  rdname: ~
  name: markInvalid
  doctype: ~
  title: Input validation
  description: |-
    `markInvalid` and `markValid` are new utilities for conveying information to
    users. Both functions can add text to an input letting a user know why an
    input is valid or invalid. Additionally, `markInvalid` will immediately
    freeze an input. As a result, further observers or reactives using the input
    are not triggered. `markValid` will immediately thaw the reactive input, thus
    allowing subsequent observers and reactives to trigger.
  parameters:
  - name: id
    description: |-
      A character string specifying the id of an input to mark as invalid
      or valid.
  - name: msg
    description: |-
      A character string letting the user know why an input is invalid
      or valid. For `markInvalid` this argument is required, for `markValid` the
      argument is optional.
  sections: ~
  examples: ''
  aliases: ~
  family: ~
  export: yes
  filename: validate.R
  source:
  - markInvalid <- function(id, msg) {
  - '  domain <- getDefaultReactiveDomain()'
  - '  if (is.null(domain)) {'
  - '    stop('
  - '      "problem with `invalid`, input `", id, "` cannot be invalidated outside
    ",'
  - '      "of a reactive context", call. = FALSE'
  - '    )'
  - '  }'
  - '  domain$sendInputMessage(id, list(type = "mark:invalid", data = list(msg = msg)))'
  - '  domain$freezeValue(domain$input, id)'
  - '  invisible()'
  - '}'
---
