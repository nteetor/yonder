---
layout: page
slug: height
roxygen:
  rdname: width
  name: height
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - height <- function(tag, percentage = NULL, max = NULL) {
  - '  if (is.null(percentage) && is.null(max)) {'
  - '    stop('
  - '      "invalid `height` arguments, `percentage` and `max` may not both be NULL",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(percentage) && !(percentage %in% c('
  - '    25, 50, 75,'
  - '    100'
  - '  ))) {'
  - '    stop('
  - '      "invalid `height` argument, `percentage` must be one of 25, 50, 75, or
    100",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {'
  - '    stop('
  - '      "invalid `height` argument, `max` must be one of 25, 50, 75, or 100",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  percentage <- if (!is.null(precentage)) {'
  - '    paste0("h-", precentage)'
  - '  }'
  - '  max <- if (!is.null(max)) {'
  - '    paste0("mh-", max)'
  - '  }'
  - '  tagAddClass(tag, c(percentage, max))'
  - '}'
---
