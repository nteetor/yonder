---
layout: page
slug: update-choices
roxygen:
  rdname: ~
  name: updateChoices
  doctype: ~
  title: Update choices, values, selected choices
  description: Functions to update choices, values, and selected choices.
  parameters:
  - name: id
    description: A character string specifying the id of an input to update.
  - name: '...'
    description: |-
      Named values or unnamed values specifying which and how existing
      or new input choices, values, or which values are selected are updated,
      values are [dots_list()] allowing the use of bangs and splices.
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: update.R
  source: |-
    updateChoices <- function(id, ...) {
        args <- dots_list(...)
        sendUpdateMessage(id, "choices", args)
    }
---
