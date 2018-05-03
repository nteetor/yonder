---
layout: page
slug: send-bar
roxygen:
  rdname: progressOutput
  name: sendBar
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
  - sendBar <- function(id, value, label = NULL, session = getDefaultReactiveDomain())
    {
  - '  session$sendProgress("dull-progress", dropNulls(list('
  - '    id = id,'
  - '    value = value, label = label'
  - '  )))'
  - '}'
---
