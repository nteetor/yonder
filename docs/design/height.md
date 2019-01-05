---
name: height
title: Tag element height
description: |-
  Utility function to change a tag element's height. Height is specified
  relative to the font size of page (browser default is 16px), relative to
  their parent element, or relative to the element's content.
parameters:
- name: .tag
  description: A tag element.
- name: size
  description: |-
    A character string or number specifying the height of the tag
      element. Possible values:

      An integer between 1 and 20, in which case the height of the element is
      relative to the font size of the page.

      `"full"`, in which case the element's height is a percentage of its
      parent's height. The height of the parent element must also be specified.
      Percentages do not account for margins or padding and may cause an element
      to extend beyond its parent.

      `"auto"`, in which case the element's height is determined by the browser.
      The browser will take into account the height, padding, margins, and border
      of the tag element's parent to keep the element from extending beyond its
      parent.

      `"screen"`, in which case the element's height is determined by the height of
      the viewport.
family: design
export: ''
examples:
- title: Numeric values
  body:
  - type: code
    content: |-
      div(
        lapply(
          seq(2, 20, by = 2),
          function(h) {
            div(h) %>%
              width(2) %>%
              height(h) %>%  # <-
              padding(l = 1) %>%
              border("black")
          }
        )
      ) %>%
        display("flex") %>%
        flex(justify = "between")
    output: |-
      <div class="d-flex justify-content-between">
        <div class="w-2 h-2 pl-1 border border-black">2</div>
        <div class="w-2 h-4 pl-1 border border-black">4</div>
        <div class="w-2 h-6 pl-1 border border-black">6</div>
        <div class="w-2 h-8 pl-1 border border-black">8</div>
        <div class="w-2 h-10 pl-1 border border-black">10</div>
        <div class="w-2 h-12 pl-1 border border-black">12</div>
        <div class="w-2 h-14 pl-1 border border-black">14</div>
        <div class="w-2 h-16 pl-1 border border-black">16</div>
        <div class="w-2 h-18 pl-1 border border-black">18</div>
        <div class="w-2 h-20 pl-1 border border-black">20</div>
      </div>
rdname: height
sections: []
layout: doc
---
