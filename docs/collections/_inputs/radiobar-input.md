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
  family: inputs
  export: yes
  filename: bars.R
  source: "radiobarInput <- function(id, choices, values = choices, selected = NULL)
    {\n    if (length(choices) != length(values)) {\n        stop(\"invalid `radiobarInput`
    arguments, `choices` and `values` must be \", \n            \"the same length\",
    call. = FALSE)\n    }\n    selected <- match2(selected, values)\n    tags$div(class
    = \"dull-radiobar-input btn-group btn-group-toggle\", \n        id = id, `data-toggle`
    = \"buttons\", lapply(seq_along(choices), \n            function(i) {\n                tags$label(class
    = collate(\"btn\", if (selected[[i]]) \n                  \"active\"), tags$input(name
    = id, type = \"radio\", \n                  `data-value` = values[[i]], autocomplete
    = \"false\", \n                  checked = if (selected[[i]]) \n                    NA),
    tags$span(choices[[i]]))\n            }))\n}"
---
