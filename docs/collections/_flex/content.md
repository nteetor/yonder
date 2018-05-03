---
layout: page
slug: content
roxygen:
  rdname: ~
  name: content
  doctype: ~
  title: Align flex items
  description: |-
    The `content` function adds Bootstrap classes to a tag element to change how
    flex item's align on the x-axis (when the flex direction is row) or on the
    y-axis (when the flex is direction is column). For more on flex directions
    see [direction].
  parameters:
  - name: default
    description: |-
      One of `"start"`, `"end"`, `"center"`, `"between"` or
      `"around"` specifying the default alignment of the element's flex items.
  - name: sm
    description: |-
      Like `default`, but the alignment is applied once the viewport is
      576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the alignment is applied once the viewport is
      768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the alignment is applied once the viewport is
      992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the alignment is applied once the viewport is
      1200 pixels wide, think large desktop.
  sections: ~
  examples: |
    lapply(1:5, tags$div) %>%
      tags$div() %>%
      display("flex") %>%
      content("center")
  aliases: ~
  family: flex
  export: yes
  filename: flex.R
  source:
  - content <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                    lg = NULL, xl = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl'
  - '  ))'
  - '  classes <- responsives("justify-content", args, c('
  - '    "start",'
  - '    "end", "center", "between", "around"'
  - '  ))'
  - '  tagAddClass(tag, collate(classes))'
  - '}'
---
