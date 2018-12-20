---
name: pre
title: Scrollable code snippets
description: |-
  The `pre` function adds a maximum height and scroll bar to the standard
  `<pre>` element.
parameters:
- name: '...'
  description: |-
    Text, tag elements, or named arguments passed as HTML attributes
    to the tag.
family: content
export: ''
examples:
- title: '## Simple example'
  body:
  - code: |-
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
    output: "<pre class=\"pre-scrollable\">\n  shinyApp(\n    ui = container(\n      row(\n
      \       column(\n        \n        )\n      )\n    )\n    server = function(input,
      output) {\n    \n    }\n  )\n</pre>"
layout: doc
---
