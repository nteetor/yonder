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
  family: utilities
  export: yes
  filename: popover.R
  source: "closePopover <- function(id) {\n    domain <- getDefaultReactiveDomain()\n
    \   if (is.null(domain)) {\n        stop(\"function `closePopover()` must be called
    in a reactive context\", \n            call. = FALSE)\n    }\n    domain$sendCustomMessage(\"dull:popover\",
    list(type = \"close\", \n        id = id))\n}"
---
