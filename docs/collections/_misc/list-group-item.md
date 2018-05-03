---
layout: page
slug: list-group-item
roxygen:
  rdname: listGroupThruput
  name: listGroupItem
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
  - listGroupItem <- function(..., value = NULL, selected = FALSE,
  - '                          disabled = FALSE) {'
  - '  tags$a(class = collate("list-group-item", if (!is.null(value)) {'
  - '    "list-group-item-action"'
  - '  } , if (selected) {'
  - '    "active"'
  - '  } , if (disabled) {'
  - '    "disabled"'
  - '  } ), `data-value` = value, ...)'
  - '}'
---
