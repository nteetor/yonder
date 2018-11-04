---
this: affix
filename: R/design.R
layout: page
include: ~
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
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>See top of page</h3>
  - type: source
    value: |2-

      div(
        span("I'm up here!") %>%
          padding(left = 3, right = 3) %>%
          background("teal")
      ) %>%
        display("flex") %>%
        flex(justify = "center") %>%
        affix("top")
  - type: output
    value: |-
      <div class="d-flex justify-content-center fixed-top">
        <span class="pr-3 pl-3 bg-teal">I'm up here!</span>
      </div>
---
