---
layout: page
slug: width
roxygen:
  rdname: ~
  name: width
  doctype: ~
  title: Tag element width and height
  description: |-
    Used in conjunction with [tagReduce] to change a tag element's width or
    height. Widths and heights are specified as percentages of the parent
    object's width or height.
  parameters:
  - name: percentage
    description: |-
      One of 25, 50, 75, or 100 specifying width or height as a
      percentage of a parent element's width or height.
  - name: max
    description: |-
      One of 25, 50, 75, or 100 specifying max width or max height as a
      percentage of a parent element's width or height.
  sections: ~
  examples: |
    tags$div() %>%
      width(25) %>%
      height(100)

    tags$div() %>%
      width(max = 75)
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - width <- function(tag, percentage = NULL, max = NULL) {
  - '  if (is.null(percentage) && is.null(max)) {'
  - '    stop('
  - '      "invalid `width` arguments, `percentage` and `max` may not both be NULL",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(percentage) && !(percentage %in% c('
  - '    25, 50, 75,'
  - '    100'
  - '  ))) {'
  - '    stop('
  - '      "invalid `width` argument, `percentage` must be one of 25, 50, 75, or 100",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {'
  - '    stop('
  - '      "invalid `width` argument, `max` must be one of 25, 50, 75, or 100",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  percentage <- if (!is.null(precentage)) {'
  - '    paste0("w-", precentage)'
  - '  }'
  - '  max <- if (!is.null(max)) {'
  - '    paste0("mw-", max)'
  - '  }'
  - '  tagAddClass(tag, c(percentage, max))'
  - '}'
---
