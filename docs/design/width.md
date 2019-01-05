---
name: width
title: Tag element width
description: |-
  Utility function to change a tag element's width. Widths are specified
  relative to the font size of page (browser default is 16px), relative to
  their parent element (i.e. 1/2 the width of their parent), or relative to the
  element's content.
parameters:
- name: .tag
  description: A tag element.
- name: size
  description: |-
    A character string or number specifying the width of the tag
      element. Possible values:

      An integer between 1 and 20, in which case the width of the element is
      relative to the font size of the page.

      `"1/2"`, `"1/3"`, `"2/3"`, `"1/4"`, `"3/4"`, `"1/5"`, `"2/5"`, `"3/5"`,
      `"4/5"`, or `"full"`, in which case the element's width is a percentage of
      its parent's width. The height of the parent element must be specified for
      percentage widths to work. Percentages do not account for margins or
      padding and may cause an element to extend beyond its parent.

      `"auto"`, in which case the element's width is determined by the browser.
      The browser will take into account the width, padding, margins, and border
      of the tag element's parent to keep the element from extending beyond its
      parent.
family: design
export: ''
examples:
- title: Numeric values
  body:
  - type: text
    content: When specifying a numeric value the width of the element is relative
      to the default font size of the page.
    output: ~
  - type: code
    content: |-
      div(
        lapply(
          1:20,
          width,
          .tag = div() %>%
            border("black") %>%
            height(4)
        )
      ) %>%
        flex(
          direction = "column",
          justify = "between"
        )
    output: |-
      <div class="flex-column justify-content-between">
        <div class="border border-black h-4 w-1"></div>
        <div class="border border-black h-4 w-2"></div>
        <div class="border border-black h-4 w-3"></div>
        <div class="border border-black h-4 w-4"></div>
        <div class="border border-black h-4 w-5"></div>
        <div class="border border-black h-4 w-6"></div>
        <div class="border border-black h-4 w-7"></div>
        <div class="border border-black h-4 w-8"></div>
        <div class="border border-black h-4 w-9"></div>
        <div class="border border-black h-4 w-10"></div>
        <div class="border border-black h-4 w-11"></div>
        <div class="border border-black h-4 w-12"></div>
        <div class="border border-black h-4 w-13"></div>
        <div class="border border-black h-4 w-14"></div>
        <div class="border border-black h-4 w-15"></div>
        <div class="border border-black h-4 w-16"></div>
        <div class="border border-black h-4 w-17"></div>
        <div class="border border-black h-4 w-18"></div>
        <div class="border border-black h-4 w-19"></div>
        <div class="border border-black h-4 w-20"></div>
      </div>
- title: Fractional values
  body:
  - type: text
    content: When specifying width as a fraction the element's width is a percentage
      of its parent's width.
    output: ~
  - type: code
    content: |-
      div() %>%
        margin(b = 3) %>%
        background("red") %>%
        height(5) %>%
        width("1/3")  # <-
    output: <div class="mb-3 bg-red h-5 w-1/3"></div>
rdname: width
sections: []
layout: doc
---
