---
layout: page
slug: radiobar-input
roxygen:
  rdname: checkbarInput
  name: radiobarInput
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: bars.R
  source:
  - radiobarInput <- function(id, choices, values = choices, selected = NULL) {
  - '  if (length(choices) != length(values)) {'
  - '    stop('
  - '      "invalid `radiobarInput` arguments, `choices` and `values` must be ",'
  - '      "the same length", call. = FALSE'
  - '    )'
  - '  }'
  - '  selected <- match2(selected, values)'
  - '  tags$div('
  - '    class = "dull-radiobar-input btn-group btn-group-toggle",'
  - '    id = id, `data-toggle` = "buttons", lapply('
  - '      seq_along(choices),'
  - '      function(i) {'
  - '        tags$label(class = collate("btn", if (selected[[i]]) {'
  - '          "active"'
  - '        } ), tags$input('
  - '          name = id, type = "radio",'
  - '          `data-value` = values[[i]], autocomplete = "false",'
  - '          checked = if (selected[[i]]) {'
  - '            NA'
  - '          }'
  - '        ), tags$span(choices[[i]]))'
  - '      }'
  - '    )'
  - '  )'
  - '}'
---
