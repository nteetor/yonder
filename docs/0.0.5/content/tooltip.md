---
this: tooltip
filename: R/tooltip.R
layout: page
roxygen:
  title: Tooltips
  description: |-
    Add a tooltip to a tag element. Tooltips may be placed above, below, left, or
    right of an element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: text
    description: The tooltip text.
  - name: placement
    description: |-
      One of `"top"`, `"right"`, `"bottom"`, or `"left"`
      specifying what side of the tag element the tooltip appears on.
  sections: ~
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - title: ''
    source: |-
      div(
        "The island of ",
        span("Yll") %>%
          tooltip("An island of south of the Commonwealth")
      )
      if (interactive()) {
        shinyApp(
          ui = container(
            checkboxInput("add", "Add more") %>%
              display("inline-block") %>%
              tooltip("How to know")
          ),
          server = function(input, output) {
          }
        )
      }
    output:
    - "<div>\n  The island of \n  <span data-toggle=\"tooltip\" data-placement=\"top\"
      title=\"An island of south of the Commonwealth\">Yll</span>\n</div>"
---
