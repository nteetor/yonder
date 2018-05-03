---
layout: page
slug: bar
roxygen:
  rdname: progressOutput
  name: bar
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: progress.R
  source:
  - bar <- function(id, value, label = NULL, striped = FALSE, ...) {
  - '  if (!is.character(id) && !is.null(id)) {'
  - '    stop('
  - '      "invalid `bar` argument, `id` must be a character string or NULL",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  value <- round(value)'
  - '  tags$div('
  - '    class = collate('
  - '      "dull-bar-output", "progress-bar",'
  - '      if (striped) {'
  - '        "progress-bar-striped"'
  - '      }'
  - '    ), id = id, role = "progressbar",'
  - '    style = paste0("width: ", value, "%"), `aria-valuemin` = "0",'
  - '    `aria-valuemax` = "100", label, ...'
  - '  )'
  - '}'
---
