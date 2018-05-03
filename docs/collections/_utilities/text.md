---
layout: page
slug: text
roxygen:
  rdname: background
  name: text
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - text <- function(tag, color, tone = 0) {
  - '  if (!(color %in% .colors)) {'
  - '    stop('
  - '      "invalid `text` argument, `color` is invalid, see ?background ",'
  - '      "details for possible colors", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!(tone %in% -2:2)) {'
  - '    stop('
  - '      "invalid `text` argument, `tone` must be one of -2, -1, 0, 1, or 2",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  colorUtility(tag, "text", color, tone)'
  - '}'
---
