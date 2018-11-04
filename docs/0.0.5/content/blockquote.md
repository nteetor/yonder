---
this: blockquote
filename: R/tags.R
layout: page
include: ~
roxygen:
  title: Cleaner blockquotes
  description: Stylized blockquotes, an updated builder function for `<blockquote>`.
  parameters:
  - name: '...'
    description: |-
      Any number of tags elements or character strings passed as child
      elements or named arguments passed as HTML attributes to the parent
      element.
  - name: source
    description: |-
      The quote source, use `tags$cite` to format the source title,
      defaults to `NULL`.
  - name: align
    description: One of `"left"` or `"right"`, defaults to `"left"`.
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

      blockquote(
        "Anyone can love a thing because.",
        "That's as easy as putting a penny in your pocket.",
        "But to love something despite.",
        "To know the flaws and love them too.",
        "That is rare and pure and perfect.",
        source = tags$span(
          "Patrick Rothfuss,", tags$cite("The Wise Man's Fear")
        )
      )
  - type: output
    value: |-
      <blockquote class="blockquote">
        Anyone can love a thing because.
        That's as easy as putting a penny in your pocket.
        But to love something despite.
        To know the flaws and love them too.
        That is rare and pure and perfect.
        <footer class="blockquote-footer">
          <span>
            Patrick Rothfuss,
            <cite>The Wise Man's Fear</cite>
          </span>
        </footer>
      </blockquote>
---
