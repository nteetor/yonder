---
layout: page
slug: container
roxygen:
  rdname: column
  name: container
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: layout
  export: yes
  filename: container.R
  source: "container <- function(..., center = FALSE) {\n    tags$div(class = if (center)
    \n        \"container\"\n    else \"container-fluid\", ..., include(\"core\"))\n}"
---
