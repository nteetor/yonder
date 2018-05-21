---
layout: page
slug: tab-content
roxygen:
  rdname: tabTabs
  name: tabContent
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: layout
  export: yes
  filename: tabs.R
  source: "tabContent <- function(tabs, ...) {\n    if (!is.character(tabs)) {\n        stop(\"invalid
    `tabContent()` argument, `tabs` must be a character string\", \n            call.
    = FALSE)\n    }\n    tags$div(class = \"tab-content\", `data-tabs` = tabs, ...,
    \n        include(\"core\"))\n}"
---
