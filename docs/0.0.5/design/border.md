---
this: border
filename: R/design.R
layout: page
roxygen:
  title: Tag element borders
  description: |-
    Use `border()` to add borders to a tag element or change the color of a tag
    element's border.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the border color, defaults to
      `NULL`, in which case the browser default is used. See below for possible
      border colors.
  - name: sides
    description: |-
      One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
      `"all"` or `"none"` specifying which sides to add a border to, defaults to
      `"all"`.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Possible colors</h3>
  - type: source
    value: |2-

      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      div(
        lapply(
          colors,
          border,
          .tag = div() %>%
            padding(5) %>%
            margin(2)
        )
      ) %>%
        display("flex") %>%
        flex(wrap = TRUE)
  - type: output
    value: |-
      <div class="d-flex flex-wrap">
        <div class="p-5 m-2 border-red border"></div>
        <div class="p-5 m-2 border-purple border"></div>
        <div class="p-5 m-2 border-indigo border"></div>
        <div class="p-5 m-2 border-blue border"></div>
        <div class="p-5 m-2 border-cyan border"></div>
        <div class="p-5 m-2 border-teal border"></div>
        <div class="p-5 m-2 border-green border"></div>
        <div class="p-5 m-2 border-yellow border"></div>
        <div class="p-5 m-2 border-amber border"></div>
        <div class="p-5 m-2 border-orange border"></div>
        <div class="p-5 m-2 border-grey border"></div>
        <div class="p-5 m-2 border-white border"></div>
      </div>
---
