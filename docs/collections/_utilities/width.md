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
  source: "width <- function(tag, percentage = NULL, max = NULL) {\n    if (is.null(percentage)
    && is.null(max)) {\n        stop(\"invalid `width` arguments, `percentage` and
    `max` may not both be NULL\", \n            call. = FALSE)\n    }\n    if (!is.null(percentage)
    && !(percentage %in% c(25, 50, 75, \n        100))) {\n        stop(\"invalid
    `width` argument, `percentage` must be one of 25, 50, 75, or 100\", \n            call.
    = FALSE)\n    }\n    if (!is.null(max) && !(max %in% c(25, 50, 75, 100))) {\n
    \       stop(\"invalid `width` argument, `max` must be one of 25, 50, 75, or 100\",
    \n            call. = FALSE)\n    }\n    percentage <- if (!is.null(precentage))
    \n        paste0(\"w-\", precentage)\n    max <- if (!is.null(max)) \n        paste0(\"mw-\",
    max)\n    tagAddClass(tag, c(percentage, max))\n}"
---
