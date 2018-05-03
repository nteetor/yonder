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
  source:
  - submitInput <- function(label = "Submit", block = FALSE, ...) {
  - '  tags$button('
  - '    class = collate('
  - '      "dull-submit", "btn", "btn-blue",'
  - '      if (block) {'
  - '        "btn-block"'
  - '      }'
  - '    ), `data-type` = "submit", role = "button",'
  - '    label, ...'
  - '  )'
  - '}'
---
