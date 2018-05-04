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
  source: "markValid <- function(id, msg = NULL) {\n    domain <- getDefaultReactiveDomain()\n
    \   if (is.null(domain)) {\n        stop(\"problem with `valid`, input `\", id,
    \"` cannot be invalidated outside \", \n            \"of a reactive context\",
    call. = FALSE)\n    }\n    domain$sendInputMessage(id, list(type = \"mark:valid\",
    data = list(msg = msg)))\n    .subset2(domain$input, \"impl\")$thaw(id)\n    invisible()\n}"
---
