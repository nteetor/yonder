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
  source: "tooltip <- function(content, text, placement = \"top\") {\n    if (!is_tag(content))
    {\n        stop(\"invalid `tooltip` argument, `content` must be a tag object\",
    \n            call. = FALSE)\n    }\n    if (!re(placement, \"top|left|bottom|right\",
    FALSE)) {\n        stop(\"invalid `tooltip` argument, `placement` must be one
    of \", \n            \"\\\"top\\\", \\\"left\\\", \\\"bottom\\\", or \\\"right\\\"\",
    call. = FALSE)\n    }\n    content$attribs$`data-toggle` <- \"tooltip\"\n    content$attribs$`data-placement`
    <- placement\n    content$attribs$title <- as.character(text)\n    content$children
    <- append(content$children, list(include(\"core\")))\n    content\n}"
---
