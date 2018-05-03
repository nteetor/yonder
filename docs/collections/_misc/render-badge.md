---
layout: page
slug: render-badge
roxygen:
  rdname: badgeOutput
  name: renderBadge
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: badge.R
  source:
  - renderBadge <- function(content, env = parent.frame(), quoted = FALSE) {
  - '  valFun <- shiny::exprToFunction(content, env, quoted)'
  - '  function() {'
  - '    list(value = valFun())'
  - '  }'
  - '}'
---
