---
layout: page
slug: form-row
roxygen:
  rdname: formGroup
  name: formRow
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: forms.R
  source: |-
    formRow <- function(...) {
        tags$div(class = "form-row", ..., include("core"))
    }
---
