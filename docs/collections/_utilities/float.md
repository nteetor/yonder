---
layout: page
slug: float
roxygen:
  rdname: ~
  name: float
  doctype: ~
  title: Float an element
  description: |-
    The `float` utility function applies Bootstrap float classes to a tag
    element. These classes cause a tag element to float to the left or right
    in its parent element. Alternatively, specify `"none"` to remove the
    element's float. The float utilities are viewport responsive.
  parameters:
  - name: tag
    description: A tag element.
  - name: default
    description: |-
      One of `"left"`, `"right"`, or `"none"` specifying the default
      float of the element.
  - name: sm
    description: |-
      Like `default`, but the float is applied once the viewport is 576
      pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the float is applied once the viewport is 768
      pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the float is applied once the viewport is 992
      pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the float is applied once the viewport is 1200
      pixels wide, think large desktop.
  sections: ~
  examples: ''
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "float <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg =
    NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    if (length(float) == 0) {\n        stop(\"invalid
    `float` arguments, at least one argument must not be NULL\", \n            call.
    = FALSE)\n    }\n    classes <- vapply(names2(args), function(nm) {\n        arg
    <- args[[nm]]\n        if (!re(arg, \"left|right|none\")) {\n            stop(\"invalid
    `float` argument, `\", nm, \"` must be one of \", \n                \"\\\"left\\\",
    \\\"right\\\", or \\\"none\\\"\", call. = FALSE)\n        }\n        if (nm ==
    \"default\") {\n            paste0(\"float-\", arg)\n        }\n        else {\n
    \           paste0(\"float-\", nm, \"-\", arg)\n        }\n    }, character(1))\n
    \   tagAddClass(tag, classes)\n}"
---
