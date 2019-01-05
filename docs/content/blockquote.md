---
name: blockquote
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
family: content
export: ''
examples:
- title: Simple example
  body:
  - type: code
    content: |-
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
    output: |-
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
rdname: blockquote
sections: []
layout: doc
---
