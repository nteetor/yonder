---
this: display
filename: R/design.R
layout: page
requires: ~
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
  - type: markdown
    value: |
      <h3>Using flexbox</h3>
  - type: markdown
    value: |
      <p>When using <code>flex()</code> be sure to set the display, too.</p>
  - type: source
    value: |2-

      div(
        lapply(
          1:5,
          function(i) {
            div() %>%
              padding(5) %>%
              margin(top = c(xs = 2), bottom = c(xs = 2)) %>%
              background("blue")
          }
        )
      ) %>%
        display("flex") %>%
        flex(
          direction = c(xs = "column", sm = "row"),
          justify = c(sm = "around")
        )
  - type: output
    value: |-
      <div class="d-flex flex-column flex-sm-row justify-content-sm-around">
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
        <div class="p-5 mt-2 mb-2 bg-blue"></div>
      </div>
  - type: markdown
    value: |
      <h3>Printing pages</h3>
  - type: markdown
    value: |
      <p>This element is not shown when the page is printed.</p>
  - type: source
    value: |2-

      div() %>%
        margin(5) %>%
        background("orange") %>%
        display(print = "none")
  - type: output
    value: <div class="m-5 bg-orange d-print-none"></div>
---
