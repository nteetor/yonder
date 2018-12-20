---
name: affix
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
family: design
export: ''
examples:
- title: '## See top of page'
  body:
  - code: |-
      div(
        span("I'm up here!") %>%
          padding(left = 3, right = 3) %>%
          background("teal")
      ) %>%
        display("flex") %>%
        flex(justify = "center") %>%
        affix("top")
    output: |-
      <div class="d-flex justify-content-center fixed-top">
        <span class="pr-3 pl-3 bg-teal">I'm up here!</span>
      </div>
layout: doc
---
