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
- title: '## A simple scroll'
  body:
  - code: |-
      div(
        lapply(
          rep("Integer placerat tristique nisl.", 20),
          p
        )
      ) %>%
        height(50) %>%
        scroll()
    output: |-
      <div class="h-50 scroll-y">
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
layout: doc
---
