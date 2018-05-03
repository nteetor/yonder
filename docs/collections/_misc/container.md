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
  source:
  - container <- function(..., fluid = TRUE) {
  - '  tags$div(class = if (fluid) {'
  - '    "container-fluid"'
  - '  } else {'
  - '    "container"'
  - '  } , ..., include("core"))'
  - '}'
---
