---
layout: page
slug: render-list-group
roxygen:
  rdname: listGroupThruput
  name: renderListGroup
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: list-group.R
  source:
  - renderListGroup <- function(..., env = parent.frame(), quoted = FALSE) {
  - '  itemsFun <- shiny::exprToFunction(list(...), env, quoted)'
  - '  function() {'
  - '    items <- lapply(itemsFun(), function(i) HTML(as.character(i)))'
  - '    list(items = items)'
  - '  }'
  - '}'
---
