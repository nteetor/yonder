---
layout: page
slug: margin
roxygen:
  rdname: padding
  name: margin
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
  source: "margin <- function(.tag, top = NULL, right = NULL, bottom = NULL, \n    left
    = NULL) {\n    possibles <- c(0:5, \"auto\")\n    this <- sys.call()\n    if (all(re(names2(this),
    \"\\\\.tag|\")) && length(this) == 3) {\n        all <- tryCatch(ensureBreakpoints(top,
    possibles), error = function(e) stop(\"invalid call to `margin()`, unexpected
    argument value \", \n            top, call. = FALSE))\n        classes <- createResponsiveClasses(all,
    \"m\")\n        return(tagAddClass(.tag, classes))\n    }\n    top <- ensureBreakpoints(top,
    possibles)\n    right <- ensureBreakpoints(right, possibles)\n    bottom <- ensureBreakpoints(bottom,
    possibles)\n    left <- ensureBreakpoints(left, possibles)\n    classes <- c(createResponsiveClasses(top,
    \"t\"), createResponsiveClasses(right, \n        \"r\"), createResponsiveClasses(bottom,
    \"b\"), createResponsiveClasses(left, \n        \"l\"))\n    if (!is.null(classes))
    {\n        classes <- paste0(\"m\", classes)\n    }\n    tagAddClass(.tag, classes)\n}"
---
