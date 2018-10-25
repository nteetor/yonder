---
this: width
filename: R/design.R
layout: page
roxygen:
  title: Tag element width and height
  description: |-
    Utility functions to change a tag element's width or height. Widths and
    heights are specified as percentages of the parent object's width or height.
  parameters:
  - name: .tag
    description: A tag element.
  - name: percentage
    description: |-
      One of 25, 50, 75, or 100 specifying width or height as a
      percentage of a parent element's width or height.
  - name: max
    description: |-
      One of 25, 50, 75, or 100 specifying max width or max height as a
      percentage of a parent element's width or height.
  sections: []
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Percentage based widths and heights</h3>
  - type: markdown
    value: |
      <p>These percentages are based on the size of the parent element.</p>
  - type: source
    value: |2-

      div(
        style = "height: 50px; width: 120px;",
        div() %>%
          width(25) %>%
          height(100) %>%
          background("yellow")
      ) %>%
        border("black")
  - type: output
    value: |-
      <div style="height: 50px; width: 120px;" class="border border-black">
        <div class="w-25 h-100 bg-yellow"></div>
      </div>
---
