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
  source: "font <- function(tag, size = NULL, weight = NULL) {\n    if (!re(weight,
    \"bold|normal|light|italic|monospace\")) {\n        stop(\"invalid `text` argument,
    `weight` must be one of \", \n            \"\\\"bold\\\", \\\"normal\\\", \\\"light\\\",
    \\\"italic\\\", or \\\"monospace\\\"\", \n            call. = FALSE)\n    }\n
    \   if (!re(size, \"([2-9]|10)x\")) {\n        stop(\"invalid `size` argument,
    `size` must be one of \", \n            \"\\\"2x\\\" through \\\"10px\\\"\", call.
    = FALSE)\n    }\n    if (!is.null(size)) {\n        size <- paste0(\"font-size-\",
    size)\n        tag <- tagDropClass(tag, \"font-size-([2-9]|10)x\")\n        tag
    <- tagAddClass(tag, size)\n    }\n    if (!is.null(weight)) {\n        if (re(weight,
    \"bold|normal|light\")) {\n            weight <- paste0(\"font-weight-\", weight)\n
    \       }\n        else {\n            weight <- paste0(\"font-\", weight)\n        }\n
    \       tag <- tagDropClass(tag, \"font-(weight-(bold|normal|light)|italic|monospace)\")\n
    \       tag <- tagAddClass(tag, weight)\n    }\n    tag\n}"
redirect_from: /docs/0.0.5/utilities/
---
