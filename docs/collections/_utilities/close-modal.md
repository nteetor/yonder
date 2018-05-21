---
layout: page
slug: close-modal
roxygen:
  rdname: sendModal
  name: closeModal
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: utilities
  export: yes
  filename: modal.R
  source: |-
    closeModal <- function(session = getDefaultReactiveDomain()) {
        session$sendCustomMessage("dull:modal", list(close = TRUE))
    }
---
