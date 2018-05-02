---
layout: page
slug: popover
roxygen:
  rdname: tooltip
  name: popover
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: |
    popover(
      buttonInput("Click me!"),
      "This text appears when the button is clicked"
    )
  aliases: ~
  family: ~
  export: yes
  filename: tooltip.R
  source: "popover <- function(content, text, placement = \"top\") {\n    if (!is_tag(content))
    {\n        stop(\"invalid `popover` argument, `content` must be a tag object\",
    \n            call. = FALSE)\n    }\n    if (!re(placement, \"top|left|bottom|right\",
    FALSE)) {\n        stop(\"invalid `popover` argument, `placement` must be one
    of \", \n            \"\\\"top\\\", \\\"left\\\", \\\"bottom\\\", or \\\"right\\\"\",
    call. = FALSE)\n    }\n    content$attribs$`data-container` <- \"body\"\n    content$attribs$`data-toggle`
    <- \"popover\"\n    content$attribs$`data-placement` <- placement\n    content$attribs$`data-content`
    <- as.character(text)\n    content$children <- c(content$children, include(\"core\"))\n
    \   content\n}"
---
