---
layout: page
slug: tooltip
roxygen:
  rdname: ~
  name: tooltip
  doctype: ~
  title: Tooltips
  description: |-
    Both functions are a means of adding help text to HTML components. Tooltips
    appear on hover. To add tooltips to text first wrap the text in a `span()` tag
    element.
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
  examples: |
    div(
      "The island of ",
      span("Yll") %>%
        tooltip("An island of south of the Commonwealth")
    )
  aliases: ~
  family: utilities
  export: yes
  filename: tooltip.R
  source: "tooltip <- function(.tag, text, placement = \"top\") {\n    if (!is_tag(.tag))
    {\n        stop(\"invalid `tooltip` argument, `.tag` must be a tag object\", \n
    \           call. = FALSE)\n    }\n    if (!re(placement, \"top|left|bottom|right\",
    FALSE)) {\n        stop(\"invalid `tooltip` argument, `placement` must be one
    of \", \n            \"\\\"top\\\", \\\"left\\\", \\\"bottom\\\", or \\\"right\\\"\",
    call. = FALSE)\n    }\n    .tag$attribs$`data-toggle` <- \"tooltip\"\n    .tag$attribs$`data-placement`
    <- placement\n    .tag$attribs$title <- as.character(text)\n    .tag$children
    <- append(.tag$children, list(include(\"core\")))\n    .tag\n}"
---
