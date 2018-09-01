---
this: affix
filename: R/utilities.R
layout: page
roxygen:
  title: Affix elements to top or bottom of page
  description: |-
    The `affix` utility function applies Bootstrap classes to fix elements to the
    top or bottom of a page. Use `"sticky"` to cause an element to fix to the top
    of a page *after* the element is scrolled past. *Important*, the IE11 and
    Edge browsers do not support the sticky behavior.
  parameters:
  - name: .tag
    description: A tag element.
  - name: position
    description: |-
      One of `"top"`, `"bottom"`, or `"sticky"` specifying the
      fixed behavior of an element.
  sections: ~
  return: ~
  family: utilities
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      tags$div("A simple banner") %>%
        width(100) %>%
        affix("top")
    output: <div class="w-100 fixed-top">A simple banner</div>
---
