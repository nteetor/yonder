---
this: border
filename: R/design.R
layout: page
requires: ~
roxygen:
  title: Tag element borders
  description: Use `border()` to add or modify tag element borders.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      One of `"red"`, `"purple"`, `"indigo"`, `"blue"`, `"cyan"`,
      `"teal"`, `"green"`, `"yellow"`, `"amber"`, `"orange"`, `"grey"`, `"white"`
      specifying the border color, defaults to `NULL`.
  - name: sides
    description: |-
      One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
      `"all"` or `"none"` specifying which sides to add a border to, defaults to
      `"all"`.
  - name: round
    description: |-
      One or more of `"top"`, `"right"`, `"bottom"`, `"left"`,
      `"circle"`, `"all"`, or `"none"` specifying how to round the border(s) of a
      tag element, defaults to `NULL`, in which case the argument is ignored.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Change border color</h3>
  - type: source
    value: |2-

      div(
        div() %>%
          height(3) %>%
          width(3) %>%
          border("green"),
        div() %>%
          height(3) %>%
          width(3) %>%
          border(
            color = "blue",
            sides = c("left", "right")
          )
      )
  - type: output
    value: |-
      <div>
        <div class="h-3 w- 3 border border-green"></div>
        <div class="h-3 w- 3 border-left border-right border-blue"></div>
      </div>
  - type: markdown
    value: |
      <h3>Round sides</h3>
  - type: source
    value: |2-

      sides <- c("top", "right", "bottom", "left", "circle", "all")

      div(
        lapply(
          sides,
          border,
          .tag = div() %>%
            height(3) %>%
            width(3),
          color = "black"
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="h-3 w- 3 border-top border-black"></div>
        <div class="h-3 w- 3 border-right border-black"></div>
        <div class="h-3 w- 3 border-bottom border-black"></div>
        <div class="h-3 w- 3 border-left border-black"></div>
        <div class="h-3 w- 3 border-circle border-black"></div>
        <div class="h-3 w- 3 border border-black"></div>
      </div>
---
