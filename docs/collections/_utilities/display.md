---
layout: page
slug: display
roxygen:
  rdname: ~
  name: display
  doctype: ~
  title: Element display property, inline, block, and more
  description: |-
    The `display` utility is used to apply Bootstrap classes to adjust a tag
    element's display property. This can be used to hide an element on small
    screens or convert an element from inline to block on large screens. Use the
    `print` argument to change the display property of an element during
    printing.
  parameters:
  - name: tag
    description: A tag element.
  - name: default
    description: |-
      One of `"inline"`, `"inline-block"`, `"block"`, `"table"`,
      `"table-cell"`, `"flex"`, `"inline-flex"`, or `"none"` specifying the
      default display property of the element.
  - name: sm
    description: |-
      Like `default`, but the display property is applied once the
      viewport is 576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the display property is applied once the
      viewport is 768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the display property is applied once the
      viewport is 992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the display property is applied once the
      viewport is 1200 pixels wide, think large desktop.
  - name: print
    description: |-
      Like `default`, but the display property is applied when the
      page is printed.
  sections: ~
  examples: |
    tags$div() %>%
      display(default = "none", md = "block")
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - display <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                    lg = NULL, xl = NULL, print = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl, print = print'
  - '  ))'
  - '  classes <- responsives(prefix = "d", values = args, possible = c('
  - '    "inline",'
  - '    "inline-block", "block", "flex", "flex-inline", "none"'
  - '  ))'
  - '  tagAddClass(tag, classes)'
  - '}'
---
