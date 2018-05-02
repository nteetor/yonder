---
layout: page
slug: container
roxygen:
  rdname: col
  name: container
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: container.R
  source: "container <- function(..., fluid = TRUE) {\n    tags$div(class = if (fluid)
    \n        \"container-fluid\"\n    else \"container\", ..., include(\"core\"))\n}"
---
