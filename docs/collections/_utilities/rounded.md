---
layout: page
slug: rounded
roxygen:
  rdname: ~
  name: rounded
  doctype: ~
  title: Round tag element corners
  description: |-
    The `rounded` utility function applies Bootstrap classes to an element. The
    styles are applied by sides, e.g. `"left"` or `"bottom"`. The `"circle"`
    value heavily rounds all the corners of an element.
  parameters:
  - name: .tag
    description: A tag element.
  - name: sides
    description: |-
      One of `"top"`, `"right"`, `"bottom"`, `"left"`, `"circle"`,
      `"all"` or `"none"`, defaults to `"all"`, specifying which and how the
      the corners of the tag element are rounded.
  sections: ~
  examples: ''
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "rounded <- function(.tag, sides = \"all\") {\n    if (!all(re(sides, \"top|right|bottom|left|circle|all|none\",
    \n        len0 = FALSE))) {\n        stop(\"invalid `rounded` argument, `sides`
    must be one of \", \n            \"\\\"top\\\", \\\"right\\\", \\\"bottom\\\",
    \\\"left\\\", \\\"circle\\\", \\\"all\\\", or \\\"none\\\"\", \n            call.
    = FALSE)\n    }\n    classes <- vapply(sides, function(s) {\n        switch(s,
    none = \"rounded-0\", all = \"rounded\", paste0(\"rounded-\", \n            s))\n
    \   }, character(1))\n    tagAddClass(.tag, classes)\n}"
---
