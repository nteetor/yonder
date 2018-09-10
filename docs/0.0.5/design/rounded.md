---
this: rounded
filename: R/design.R
layout: page
roxygen:
  title: Round tag element borders
  description: |-
    The `rounded` utility function applies Bootstrap classes to an element. The
    styles are applied by sides, e.g. `"left"` or `"bottom"`. The `"circle"`
    value heavily rounds all the corners of an element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: sides
    description: |-
      One of `"top"`, `"right"`, `"bottom"`, `"left"`, `"circle"`,
      `"all"` or `"none"`, defaults to `"all"`, specifying which and how the
      the corners of the tag element are rounded.
  sections: ~
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>Different sides</h2>
  - type: source
    value: |2-

      sides <- c("top", "right", "bottom", "left", "circle", "all")

      div(
        lapply(
          sides,
          rounded,
          .tag = div() %>%
            padding(5) %>%
            margin(2) %>%
            border("indigo")
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="p-5 m-2 border-indigo border rounded-top"></div>
        <div class="p-5 m-2 border-indigo border rounded-right"></div>
        <div class="p-5 m-2 border-indigo border rounded-bottom"></div>
        <div class="p-5 m-2 border-indigo border rounded-left"></div>
        <div class="p-5 m-2 border-indigo border rounded-circle"></div>
        <div class="p-5 m-2 border-indigo border rounded"></div>
      </div>
---
