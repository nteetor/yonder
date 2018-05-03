---
layout: page
slug: figure
roxygen:
  rdname: img
  name: figure
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: content
  export: yes
  filename: tags.R
  source:
  - figure <- function(image, caption = NULL, ...) {
  - '  if (!is_tag(image)) {'
  - '    stop('
  - '      "invalid `figure` argument, `image` must be a tag element",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  tags$figure('
  - '    class = "figure", tagAddClass(image, "figure-img"),'
  - '    if (!is.null(caption)) {'
  - '      tags$figcaption(class = "figure-caption", caption)'
  - '    }, ..., include("core")'
  - '  )'
  - '}'
---
