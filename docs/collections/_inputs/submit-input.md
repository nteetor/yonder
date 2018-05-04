---
layout: page
slug: submit-input
roxygen:
  rdname: buttonInput
  name: submitInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: inputs
  export: yes
  filename: button.R
  source: "submitInput <- function(label = \"Submit\", block = FALSE, ...) {\n    tags$button(class
    = collate(\"dull-submit\", \"btn\", \"btn-blue\", \n        if (block) \n            \"btn-block\"),
    `data-type` = \"submit\", role = \"button\", \n        label, ...)\n}"
---
