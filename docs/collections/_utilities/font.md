---
layout: page
slug: font
roxygen:
  rdname: ~
  name: font
  doctype: ~
  title: Text font
  description: |-
    The `font` utility changes the weight and size of an element's text font.
    Bold fonts are darker and heavier whereas light fonts are thinner. Font
    size's are changed relative to the current font size.
  parameters:
  - name: tag
    description: A tag element.
  - name: size
    description: |-
      One of `"2x"`, `"3x"`, ..., or `"10x"` specifying a factor to
      increase a tag element's font size by (e.g. `"2x"` is double the base font
      size), defaults to `NULL`, in which case the font size is unchanged.
  - name: weight
    description: |-
      One of `"bold"`, `"normal"`, `"light"`, `"italic"`, or
      `"monospace"` specifying the font weight of the element's text, defaults to
      `NULL`, in which case the font is unchanged.
  sections: ~
  examples: |
    span("This and other news") %>%
      font(weight = "light")

    icon("anchor") %>%
      font("5x")

    p("Ipsum Consectetur Nibh Bibendum Ullamcorper") %>%
      font("2x", "monospace") %>%
      font(weight = "italic")
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - font <- function(tag, size = NULL, weight = NULL) {
  - '  if (!re(weight, "bold|normal|light|italic|monospace")) {'
  - '    stop('
  - '      "invalid `text` argument, `weight` must be one of ",'
  - '      "\"bold\", \"normal\", \"light\", \"italic\", or \"monospace\"",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!re(size, "([2-9]|10)x")) {'
  - '    stop('
  - '      "invalid `size` argument, `size` must be one of ",'
  - '      "\"2x\" through \"10px\"", call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(size)) {'
  - '    size <- paste0("font-size-", size)'
  - '    tag <- tagDropClass(tag, "font-size-([2-9]|10)x")'
  - '    tag <- tagAddClass(tag, size)'
  - '  }'
  - '  if (!is.null(weight)) {'
  - '    if (re(weight, "bold|normal|light")) {'
  - '      weight <- paste0("font-weight-", weight)'
  - '    }'
  - '    else {'
  - '      weight <- paste0("font-", weight)'
  - '    }'
  - '    tag <- tagDropClass(tag, "font-(weight-(bold|normal|light)|italic|monospace)")'
  - '    tag <- tagAddClass(tag, weight)'
  - '  }'
  - '  tag'
  - '}'
redirect_from: /docs/0.0.5/utilities/
---
