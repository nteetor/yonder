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
  source: "margins <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg
    = NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    if (length(args) == 0) {\n        stop(\"invalid
    `margins` arguments, at least one argument must not be NULL\", \n            call.
    = FALSE)\n    }\n    prefix <- \"m\"\n    sides <- c(\"t\", \"r\", \"b\", \"l\")\n
    \   classes <- vapply(names2(args), function(nm) {\n        arg <- args[[nm]]\n
    \       if (length(arg) != 4 && length(arg) != 1) {\n            stop(\"invalid
    `margins` argument, `\", nm, \"` must be a single value or a \", \n                \"vector
    of four values\", call. = FALSE)\n        }\n        if (!all(re(arg, \"[0-5]|auto\",
    len0 = FALSE))) {\n            stop(\"invalid `margins` argument, `\", nm, \"`
    value(s) must be \", \n                \"0, 1, 2, 3, 4, 5, or \\\"auto\\\"\",
    call. = FALSE)\n        }\n        breakpoint <- if (nm == \"default\") \n            \"-\"\n
    \       else paste0(\"-\", nm, \"-\")\n        if (length(arg) == 4) {\n            return(paste0(prefix,
    sides, breakpoint, arg, collapse = \" \"))\n        }\n        paste0(prefix,
    breakpoint, arg)\n    }, character(1))\n    tagAddClass(tag, classes)\n}"
---
