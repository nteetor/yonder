---
this: pre
filename: R/tags.R
layout: page
requires: ~
roxygen:
  title: Scrollable code snippets
  description: |-
    The `pre` function adds a maximum height and scroll bar to the standard
    `<pre>` element.
  parameters:
  - name: '...'
    description: |-
      Text, tag elements, or named arguments passed as HTML attributes
      to the tag.
  sections: []
  return: ~
  family: content
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Simple example</h3>
  - type: source
    value: |2-

      pre(
        "shinyApp(",
        "  ui = container(",
        "    row(",
        "      column(",
        "      ",
        "      )",
        "    )",
        "  )",
        "  server = function(input, output) {",
        "  ",
        "  }",
        ")"
      )
  - type: output
    value: "<pre class=\"pre-scrollable\">\n  shinyApp(\n    ui = container(\n      row(\n
      \       column(\n        \n        )\n      )\n    )\n    server = function(input,
      output) {\n    \n    }\n  )\n</pre>"
---
