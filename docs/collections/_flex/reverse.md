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
  source: "reverse <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg
    = NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    classes <- responsives(\"flex\", args,
    c(\"row\", \"column\"))\n    classes <- paste0(classes, \"-reverse\")\n    tagAddClass(tag,
    collate(classes))\n}"
---
