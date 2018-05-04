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
  source: "bar <- function(id, value, label = NULL, striped = FALSE, ...) {\n    if
    (!is.character(id) && !is.null(id)) {\n        stop(\"invalid `bar` argument,
    `id` must be a character string or NULL\", \n            call. = FALSE)\n    }\n
    \   value <- round(value)\n    tags$div(class = collate(\"dull-bar-output\", \"progress-bar\",
    \n        if (striped) \n            \"progress-bar-striped\"), id = id, role
    = \"progressbar\", \n        style = paste0(\"width: \", value, \"%\"), `aria-valuemin`
    = \"0\", \n        `aria-valuemax` = \"100\", label, ...)\n}"
---
