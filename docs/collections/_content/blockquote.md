---
layout: page
slug: blockquote
roxygen:
  rdname: ~
  name: blockquote
  doctype: ~
  title: Cleaner blockquotes
  description: Stylized blockquotes, an updated builder function for `<blockquote>`.
  parameters:
  - name: source
    description: |-
      The quote source, use `tags$cite` to format the source title,
      defaults to `NULL`.
  - name: align
    description: One of `"left"` or `"right"`, defaults to `"left"`.
  sections: ~
  examples: |
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
  aliases: ~
  family: content
  export: yes
  filename: tags.R
  source:
  - blockquote <- function(..., source = NULL, align = "left") {
  - '  tags$blockquote(class = collate("blockquote", if (align =='
  - '    "right") {'
  - '    "blockquote-reverse"'
  - '  } ), ..., if (!is.null(source)) {'
  - '    tags$footer(class = "blockquote-footer", source)'
  - '  }, include("core"))'
  - '}'
---
