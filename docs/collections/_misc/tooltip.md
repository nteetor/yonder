---
layout: page
slug: tooltip
roxygen:
  rdname: ~
  name: tooltip
  doctype: ~
  title: Add Tooltips and Popovers
  description: |-
    Both functions are a means of adding help text to HTML components. Tooltips
    appear on hover and popovers appear when the element is clicked.
  parameters:
  - name: content
    description: The tag to add a tooltip or popover to.
  - name: text
    description: The tooltip or popover text.
  - name: placement
    description: |-
      A character vector specifying where the tooltip or popover
      is placed, defaults to top, one of `"left"`, `"top"`, `"right"`, or
      `"bottom"`.
  sections: ~
  examples: ''
  aliases: ~
  family: ~
  export: yes
  filename: tooltip.R
  source:
  - tooltip <- function(content, text, placement = "top") {
  - '  if (!is_tag(content)) {'
  - '    stop('
  - '      "invalid `tooltip` argument, `content` must be a tag object",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!re(placement, "top|left|bottom|right", FALSE)) {'
  - '    stop('
  - '      "invalid `tooltip` argument, `placement` must be one of ",'
  - '      "\"top\", \"left\", \"bottom\", or \"right\"", call. = FALSE'
  - '    )'
  - '  }'
  - '  content$attribs$`data-toggle` <- "tooltip"'
  - '  content$attribs$`data-placement` <- placement'
  - '  content$attribs$title <- as.character(text)'
  - '  content$children <- append(content$children, list(include("core")))'
  - '  content'
  - '}'
---
