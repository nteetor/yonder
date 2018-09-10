---
this: height
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
  sections: ~
  return: ~
  family: design
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h2>Getting started</h2>
  - type: source
    value: |2-

      tags$div() %>%
        width(25) %>%
        height(100)

      tags$div() %>%
        width(max = 75)
  - type: output
    value: <div class="mw-75"></div>
---
