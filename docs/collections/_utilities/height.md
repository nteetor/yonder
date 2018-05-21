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
  source: "height <- function(.tag, percentage = NULL, max = NULL) {\n    if (is.null(percentage)
    && is.null(max)) {\n        stop(\"invalid `height` arguments, `percentage` and
    `max` may not both be NULL\", \n            call. = FALSE)\n    }\n    if (!is.null(percentage)
    && !(percentage %in% c(25, 50, 75, \n        100))) {\n        stop(\"invalid
    `height` argument, `percentage` must be one of 25, 50, 75, or 100\", \n            call.
    = FALSE)\n    }\n    if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {\n
    \       stop(\"invalid `height` argument, `max` must be one of 25, 50, 75, or
    100\", \n            call. = FALSE)\n    }\n    percentage <- if (!is.null(percentage))
    \n        paste0(\"h-\", percentage)\n    max <- if (!is.null(max)) \n        paste0(\"mh-\",
    max)\n    tagAddClass(.tag, c(percentage, max))\n}"
---
