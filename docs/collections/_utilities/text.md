---
layout: page
slug: text
roxygen:
  rdname: background
  name: text
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "text <- function(tag, color, tone = 0) {\n    if (!(color %in% .colors))
    {\n        stop(\"invalid `text` argument, `color` is invalid, see ?background
    \", \n            \"details for possible colors\", call. = FALSE)\n    }\n    if
    (!(tone %in% -2:2)) {\n        stop(\"invalid `text` argument, `tone` must be
    one of -2, -1, 0, 1, or 2\", \n            call. = FALSE)\n    }\n    colorUtility(tag,
    \"text\", color, tone)\n}"
---
