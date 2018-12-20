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
- title: '## Numeric values'
  body:
  - code: ''
    output: []
- title: When specifying a numeric value the width of the element is relative to the
    default font size of the page.
  body:
  - code: |-
      lapply(
        1:20,
        width,
        .tag = div() %>%
          border("black") %>%
          height(4)
      )
    output:
    - list(name = "div", attribs = list(class = "border border-black h-4 w-1"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-2"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-3"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-4"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-5"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-6"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-7"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-8"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-9"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-10"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-11"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-12"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-13"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-14"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-15"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-16"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-17"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-18"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-19"), children
      = list())
    - list(name = "div", attribs = list(class = "border border-black h-4 w-20"), children
      = list())
- title: '## Fractional values'
  body:
  - code: ''
    output: []
- title: When specifying a fraction the element's width is a percentage of its parent's
    width.
  body:
  - code: |-
      div(
        div() %>%
          margin(b = 3) %>%
          border("red") %>%
          width("1/3")
      ) %>%
        width(20)
    output: |-
      <div class="w-20">
        <div class="mb-3 border border-red w-1/3"></div>
      </div>
layout: doc
---
