---
layout: page
slug: items
roxygen:
  rdname: ~
  name: items
  doctype: ~
  title: Flex items, cross axis alignment
  description: |-
    The `items` utility function applies Bootstrap classes to a tag element in
    order to change the cross axis alignment of its flex items. The element must
    must use a flex display. To change the display property of a tag, see
    [display] for more information.
  parameters:
  - name: default
    description: |-
      One of `"start"`, `"end"`, `"center"`, `"baseline"` or
      `"stretch"` specifying the default cross axis alignment of the element's
      flex items.
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
  sections:
  - - 'Alignments:'
    - '**`"start"`**, flex items are aligned at the top of the parent element.'
    - |-
      ```
      | Item 1 | Item 2 | Item 3 | ============= |
      |        |        |        |               |
      |        |        |        |               |
      ```
    - '**`"end"`**, flex items are aligned at the bottom of the parent element.'
    - |-
      ```
      |        |        |        |               |
      |        |        |        |               |
      | Item 1 | Item 2 | Item 3 | ============= |
      ```
    - '**`"center"`**, flex items are aligned at the center of the parent element.'
    - |-
      ```
      |        |        |        |               |
      | Item 1 | Item 2 | Item 3 | ============= |
      |        |        |        |               |
      ```
    - '**`"baseline"`**, flex items are aligned by font size.'
    - |-
      ```
      | Item 1 | Item 2 | Item 3 | ============= |
      |        |        |        |               |
      |        |        |        |               |
      ```
    - |-
      **`"stretch"`**, flex items stretch to fill the height of their parent
      element. This is the browser defalut.
    - |-
      ```
      | It     | It     | It     | ============= |
      |   em   |   em   |   em   |               |
      |      1 |      2 |      3 |               |
      ```
  examples: ''
  aliases: ~
  family: flex
  export: yes
  filename: flex.R
  source: "items <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg =
    NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    classes <- responsives(\"align-items\",
    args, c(\"start\", \"end\", \n        \"center\", \"baseline\", \"stretch\"))\n
    \   tagAddClass(tag, collate(classes))\n}"
---
