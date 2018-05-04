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
  source: "figure <- function(image, caption = NULL, ...) {\n    if (!is_tag(image))
    {\n        stop(\"invalid `figure` argument, `image` must be a tag element\",
    \n            call. = FALSE)\n    }\n    tags$figure(class = \"figure\", tagAddClass(image,
    \"figure-img\"), \n        if (!is.null(caption)) {\n            tags$figcaption(class
    = \"figure-caption\", caption)\n        }, ..., include(\"core\"))\n}"
---
