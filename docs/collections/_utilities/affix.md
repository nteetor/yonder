---
layout: page
slug: affix
roxygen:
  rdname: ~
  name: affix
  doctype: ~
  title: Affix elements to top or bottom of page
  description: |-
    The `affix` utility function applies Bootstrap classes to fix elements to the
    top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
    of a page *after* the element is scrolled past. *Important*, the IE11 and
    Edge browsers do not support the sticky behavior.
  parameters:
  - name: tag
    description: A tag element.
  - name: position
    description: |-
      One of `"top"`, `"bottom"`, or `"sticky"` specifying the
      fixed behavior of an element.
  sections: ~
  examples: |
    tags$div("A simple banner") %>%
      width(100) %>%
      affix("top")
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - affix <- function(tag, position) {
  - '  if (!re(position, "top|bottom|sticky", len0 = FALSE)) {'
  - '    stop('
  - '      "invalid `affix` argument, `position` must be one of ",'
  - '      "\"top\", \"bottom\", or \"sticky\"", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (position == "sticky") {'
  - '    tagAddClass(tag, "sticky-top")'
  - '  }'
  - '  else {'
  - '    tagAddClass(tag, paste0("fixed-", position))'
  - '  }'
  - '}'
---
