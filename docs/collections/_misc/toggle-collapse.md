---
layout: page
slug: toggle-collapse
roxygen:
  rdname: collapse
  name: toggleCollapse
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: collapse.R
  source:
  - toggleCollapse <- function(id, session = getDefaultReactiveDomain()) {
  - '  updateCollapse(id, "toggle", session)'
  - '}'
---
