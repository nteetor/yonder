---
layout: page
slug: tab-content
roxygen:
  rdname: tabTabs
  name: tabContent
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: tabs.R
  source:
  - tabContent <- function(tabs, ...) {
  - '  tags$div('
  - '    class = "tab-content", `data-tabs` = tabs, ...,'
  - '    include("core")'
  - '  )'
  - '}'
---
