---
layout: page
slug: mark-valid
roxygen:
  rdname: markInvalid
  name: markValid
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: ~
  export: yes
  filename: validate.R
  source:
  - markValid <- function(id, msg = NULL) {
  - '  domain <- getDefaultReactiveDomain()'
  - '  if (is.null(domain)) {'
  - '    stop('
  - '      "problem with `valid`, input `", id, "` cannot be invalidated outside ",'
  - '      "of a reactive context", call. = FALSE'
  - '    )'
  - '  }'
  - '  domain$sendInputMessage(id, list(type = "mark:valid", data = list(msg = msg)))'
  - '  .subset2(domain$input, "impl")$thaw(id)'
  - '  invisible()'
  - '}'
---
