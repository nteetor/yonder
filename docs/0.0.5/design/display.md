---
this: display
filename: R/design.R
layout: page
roxygen:
  title: Tag element display
  description: |-
    Use the `display()` utility to adjust how a tag element is rendered. All
    arguments are responsive allowing you to hide elements on small screens or
    convert elements from inline to block on large screens. Most of the time
    you will use the `render` argument. However if you want to control how an
    element appears (or does not appear) when the page is printed use the `print`
    argument.
  parameters:
  - name: .tag
    description: A tag element.
  - name: render,print
    description: |-
      A [responsive](/yonder/0.0.5/responsive.html) argument. One of `"inline"`, `"block"`,
      `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`, defaults to
      `NULL`.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: source
    value: |2-


      display(div(), render = c(xs = "none", md = "block"))

      display(div(), render = c(xs = "inline", sm = "block"))

      display(div(), print = "none")
  - type: output
    value: <div class="d-print-none"></div>
---
