---
layout: page
slug: reverse
roxygen:
  rdname: direction
  name: reverse
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: flex
  export: yes
  filename: flex.R
  source:
  - reverse <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                    lg = NULL, xl = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl'
  - '  ))'
  - '  classes <- responsives("flex", args, c("row", "column"))'
  - '  classes <- paste0(classes, "-reverse")'
  - '  tagAddClass(tag, collate(classes))'
  - '}'
---
