---
layout: page
slug: update-values
roxygen:
  rdname: updateChoices
  name: updateValues
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: update.R
  source:
  - updateValues <- function(id, ...) {
  - '  args <- dots_list(...)'
  - '  sendUpdateMessage(id, "values", args)'
  - '}'
---
