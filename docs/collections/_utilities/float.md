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
  source:
  - float <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                  lg = NULL, xl = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl'
  - '  ))'
  - '  if (length(float) == 0) {'
  - '    stop('
  - '      "invalid `float` arguments, at least one argument must not be NULL",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  classes <- vapply(names2(args), function(nm) {'
  - '    arg <- args[[nm]]'
  - '    if (!re(arg, "left|right|none")) {'
  - '      stop('
  - '        "invalid `float` argument, `", nm, "` must be one of ",'
  - '        "\"left\", \"right\", or \"none\"", call. = FALSE'
  - '      )'
  - '    }'
  - '    if (nm == "default") {'
  - '      paste0("float-", arg)'
  - '    }'
  - '    else {'
  - '      paste0("float-", nm, "-", arg)'
  - '    }'
  - '  }, character(1))'
  - '  tagAddClass(tag, classes)'
  - '}'
---
