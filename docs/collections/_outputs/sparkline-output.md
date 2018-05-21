---
layout: page
slug: sparkline-output
roxygen:
  rdname: ~
  name: sparklineOutput
  doctype: ~
  title: Sparkline output
  description: Display concise, reactive inline bar, line, or dot charts.
  parameters:
  - name: id
    description: A character string specifying the id of the sparkline output.
  - name: type
    description: |-
      One of `"bar"`, `"dot"`, or `"line"` specifying the type of
      chart to render, defaults to `"bar"`.
  - name: labels
    description: |-
      If `TRUE`, the first and last value of the sparkline data
      are used as labels, defaults to `TRUE`.
  - name: values
    description: |-
      A numeric vector of values specifying the sparkline data
      points. Bar and dot sparklines expect values to be between 0 and 100 and
      line sparklines expect values to be between 0 and 10.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attributes to the parent
      element.
  - name: env
    description: The environment in which to evaluate `values`.
  - name: quoted
    description: |-
      One of `TRUE` or `FALSE` specifying if `values` is a quoted
      expression.
  sections: ~
  examples: ''
  aliases: ~
  family: outputs
  export: yes
  filename: sparkline.R
  source: "sparklineOutput <- function(id, type = \"bar\", labels = TRUE, \n    ...)
    {\n    if (!re(type, \"bar|dot|line\", FALSE)) {\n        stop(\"invalid `sparklineOutput`
    argument, `type` must be one of \", \n            \"\\\"bar\\\", \\\"dot\\\",
    or \\\"line\\\"\", call. = FALSE)\n    }\n    tags$span(class = collate(\"dull-sparkline-output\",
    paste0(\"spark-\", \n        type, \"-medium\")), id = id, `data-labels` = if
    (labels) \n        \"true\"\n    else \"false\", ...)\n}"
redirect_from: /docs/0.0.5/outputs/
---
