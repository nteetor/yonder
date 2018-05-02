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
  source: "listGroupItem <- function(..., value = NULL, selected = FALSE, \n    disabled
    = FALSE) {\n    tags$a(class = collate(\"list-group-item\", if (!is.null(value))
    \n        \"list-group-item-action\", if (selected) \n        \"active\", if (disabled)
    \n        \"disabled\"), `data-value` = value, ...)\n}"
---
