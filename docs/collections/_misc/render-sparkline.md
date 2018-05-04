---
layout: page
slug: render-sparkline
roxygen:
  rdname: sparklineOutput
  name: renderSparkline
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: sparkline.R
  source: |-
    renderSparkline <- function(values, env = parent.frame(), quoted = FALSE) {
        valuesFun <- shiny::exprToFunction(values, env, quoted)
        function() {
            list(values = as.numeric(valuesFun()))
        }
    }
---
