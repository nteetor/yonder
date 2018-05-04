---
layout: page
slug: stop-spinner
roxygen:
  rdname: spinnerOutput
  name: stopSpinner
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
    stopSpinner <- function(id, session = getDefaultReactiveDomain()) {
        session$sendProgress("dull-spinner", list(id = id, action = "stop"))
    }
---
