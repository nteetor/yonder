---
layout: page
slug: fieldset
roxygen:
  rdname: ~
  name: fieldset
  doctype: ~
  title: Group and label multiple inputs
  description: |-
    Use `fieldset` to associate and label inputs. Good for screen readers and
    other assitive technologies.
  parameters:
  - name: legend
    description: A character string specifying the fieldset's legend.
  - name: '...'
    description: |-
      Any number of inputs to group or named arguments passed as HTML
      attributes to the parent element.
  sections: ~
  examples: |
    stub
  aliases: ~
  family: ~
  export: yes
  filename: textual.R
  source: "fieldset <- function(legend, ...) {\n    if (!is.character(legend)) {\n
    \       stop(\"invalid `fieldset` argument, `legend` must be a character string\",
    \n            call. = FALSE)\n    }\n    args <- list(...)\n    attrs <- attribs(args)\n
    \   inputs <- elements(args)\n    tagConcatAttributes(tags$fieldset(class = \"form-group\",
    tags$legend(class = \"col-form-legend\", \n        legend), tags$div(inputs)),
    attrs)\n}"
---
