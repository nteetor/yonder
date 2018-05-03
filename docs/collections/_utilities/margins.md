---
layout: page
slug: margins
roxygen:
  rdname: padding
  name: margins
  doctype: ~
  title: ~
  description: ~
  parameters: ~
  sections: ~
  examples: ~
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source:
  - margins <- function(tag, default = NULL, sm = NULL, md = NULL,
  - '                    lg = NULL, xl = NULL) {'
  - '  args <- dropNulls(list('
  - '    default = default, sm = sm, md = md,'
  - '    lg = lg, xl = xl'
  - '  ))'
  - '  if (length(args) == 0) {'
  - '    stop('
  - '      "invalid `margins` arguments, at least one argument must not be NULL",'
  - '      call. = FALSE'
  - '    )'
  - '  }'
  - '  prefix <- "m"'
  - '  sides <- c("t", "r", "b", "l")'
  - '  classes <- vapply(names2(args), function(nm) {'
  - '    arg <- args[[nm]]'
  - '    if (length(arg) != 4 && length(arg) != 1) {'
  - '      stop('
  - '        "invalid `margins` argument, `", nm, "` must be a single value or a ",'
  - '        "vector of four values", call. = FALSE'
  - '      )'
  - '    }'
  - '    if (!all(re(arg, "[0-5]|auto", len0 = FALSE))) {'
  - '      stop('
  - '        "invalid `margins` argument, `", nm, "` value(s) must be ",'
  - '        "0, 1, 2, 3, 4, 5, or \"auto\"", call. = FALSE'
  - '      )'
  - '    }'
  - '    breakpoint <- if (nm == "default") {'
  - '      "-"'
  - '    } else {'
  - '      paste0("-", nm, "-")'
  - '    }'
  - '    if (length(arg) == 4) {'
  - '      return(paste0(prefix, sides, breakpoint, arg, collapse = " "))'
  - '    }'
  - '    paste0(prefix, breakpoint, arg)'
  - '  }, character(1))'
  - '  tagAddClass(tag, classes)'
  - '}'
---
