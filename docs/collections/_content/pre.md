---
layout: page
slug: pre
roxygen:
  rdname: ~
  name: pre
  doctype: ~
  title: Scrollable code snippets
  description: |-
    The `pre` function adds a maximum height and scroll bar to the standard
    `<pre>` element.
  parameters:
  - name: '...'
    description: |-
      Text, tag elements, or named arguments passed as HTML attributes
      to the tag.
  sections: ~
  examples: ''
  aliases: ~
  family: content
  export: yes
  filename: tags.R
  source:
  - pre <- function(...) {
  - '  tags$pre(class = "pre-scrollable", ...)'
  - '}'
---
