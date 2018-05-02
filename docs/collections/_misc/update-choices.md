---
layout: page
slug: update-choices
roxygen:
  rdname: ~
  name: updateChoices
  doctype: ~
  title: Update choices, values, selected choices
  description: Functions to update choices, values, and selected choices.
  parameters: ~
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
