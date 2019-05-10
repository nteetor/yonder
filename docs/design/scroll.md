---
name: scroll
title: Vertical and horizontal scroll
description: |-
  Many of the applications you build depsite a complex layout will still fit
  onto a single page. To help scroll long content alongside shorter content use
  the `scroll()` utility function.
parameters:
- name: tag
  description: A tag element.
- name: direction
  description: |-
    One of `"horizontal"` or `"vertical"` specifying which
    direction to scroll overflowing content, defaults to `"vertical"`, in which
    case the content may croll up and down.
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
          . %>% p() %>% margin(bottom = 2)
        )
      ) %>%
        height(20) %>%
        border("black") %>%
        scroll()
    output: |-
      <div class="h-20 border border-black scroll-y">
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
        <p class="mb-2">Integer placerat tristique nisl.</p>
      </div>
rdname: scroll
sections: []
layout: doc
---
