---
layout: page
slug: start-spinner
roxygen:
  rdname: spinnerOutput
  name: startSpinner
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: icons.R
  source: |-
    startSpinner <- function(id, session = getDefaultReactiveDomain()) {
        session$sendProgress("dull-spinner", list(id = id, action = "start"))
    }
---
