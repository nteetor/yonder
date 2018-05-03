---
layout: page
slug: alignment
roxygen:
  rdname: ~
  name: alignment
  doctype: ~
  title: Align element text
  description: |-
    The `alignment` utility applies Bootstrap classes to change how an element's
    text is aligned. Like with [display] or [padding] different text alignments
    can be applied based on the viewport size.
  parameters:
  - name: tag
    description: A tag object.
  - name: default
    description: |-
      One of `"left"`, `"right"`, `"center"`, or `"justified"`
      specifying the default text alignment of the element.
  - name: sm
    description: |-
      Like `default`, but the text alignment is applied once the viewport
      is 576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the text alignment is applied once the
      viewport is 768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the text alignment is applied once the
      viewport is 992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the text alignment is applied once the
      viewport is 1200 pixels wide, think large desktop.
  sections: ~
  examples: ''
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - alignment <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                      lg = NULL, xl = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl'
  - '  ))'
  - '  classes <- responsives(prefix = "text", values = args, possible = c('
  - '    "left",'
  - '    "right", "center", "justify"'
  - '  ))'
  - '  tagAddClass(tag, classes)'
  - '}'
---
