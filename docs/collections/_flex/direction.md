---
layout: page
slug: direction
roxygen:
  rdname: ~
  name: direction
  doctype: ~
  title: Flex direction, rows and columns
  description: |-
    Change the direction of a flex boxes items. `reverse` is similar to
    `direction`, but for `"row"` flex items start from the right of the parent
    flex box and for `"column"` flex items start from the bottom of the parent
    flex box.
  parameters:
  - name: tag
    description: A tag element.
  - name: default
    description: |-
      One of `"row"` or `"column"` specifying the default direction
      of an element's flex items.
  - name: sm
    description: |-
      Like `default`, but the direction is applied once the viewport is
      576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the direction is applied once the viewport is
      768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the direction is applied once the viewport is
      992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the direction is applied once the viewport is
      1200 pixels wide, think large desktop.
  sections: ~
  examples: ''
  aliases: ~
  family: flex
  export: yes
  filename: flex.R
  source: "direction <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg
    = NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    classes <- responsives(\"flex\", args,
    c(\"row\", \"column\"))\n    tagAddClass(tag, collate(classes))\n}"
redirect_from: /docs/0.0.5/flex/
---
