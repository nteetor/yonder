---
layout: page
slug: row
roxygen:
  rdname: column
  name: row
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
  source: "row <- function(..., gutters = TRUE) {\n    tags$div(class = collate(\"row\",
    if (!gutters) \n        \"no-gutter\"), ..., include(\"core\"))\n}"
---
