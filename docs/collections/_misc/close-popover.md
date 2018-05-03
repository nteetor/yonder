---
layout: page
slug: close-popover
roxygen:
  rdname: showPopover
  name: closePopover
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: popover.R
  source:
  - closePopover <- function(id) {
  - '  domain <- getDefaultReactiveDomain()'
  - '  if (is.null(domain)) {'
  - '    stop('
  - '      "function `closePopover()` must be called in a reactive context",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  domain$sendCustomMessage("dull:popover", list('
  - '    type = "close",'
  - '    id = id'
  - '  ))'
  - '}'
---
