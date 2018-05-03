---
layout: page
slug: popover
roxygen:
  rdname: tooltip
  name: popover
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    popover(
      buttonInput("Click me!"),
      "This text appears when the button is clicked"
    )
  aliases: ~
  family: ~
  export: yes
  filename: tooltip.R
  source:
  - popover <- function(content, text, placement = "top") {
  - '  if (!is_tag(content)) {'
  - '    stop('
  - '      "invalid `popover` argument, `content` must be a tag object",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!re(placement, "top|left|bottom|right", FALSE)) {'
  - '    stop('
  - '      "invalid `popover` argument, `placement` must be one of ",'
  - '      "\"top\", \"left\", \"bottom\", or \"right\"", call. = FALSE'
  - '    )'
  - '  }'
  - '  content$attribs$`data-container` <- "body"'
  - '  content$attribs$`data-toggle` <- "popover"'
  - '  content$attribs$`data-placement` <- placement'
  - '  content$attribs$`data-content` <- as.character(text)'
  - '  content$children <- c(content$children, include("core"))'
  - '  content'
  - '}'
---
