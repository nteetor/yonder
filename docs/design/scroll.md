---
name: scroll
title: Vertical and horizontal scroll
description: |-
  Many of the applications you build depsite a complex layout will still fit
  onto a single page. To help scroll long content along side shorter content
  use the `scroll()` utility function.
parameters:
- name: .tag
  description: A tag element.
- name: direction
  description: |-
    One of `"x"` or `"y"` specifying which direction to scroll
    the tag's content, defaults to `"y"`, in which case vertical scroll is
    applied.
family: design
export: ''
examples:
- title: A simple scroll
  body:
  - type: code
    content: |-
      div(
        lapply(
          rep("Integer placerat tristique nisl.", 20),
          p
        )
      ) %>%
        height(20) %>%
        border() %>%
        scroll()
    output: |-
      <div class="h-20 border scroll-y">
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
        <p>Integer placerat tristique nisl.</p>
      </div>
rdname: scroll
sections: []
layout: doc
---
