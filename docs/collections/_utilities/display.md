---
layout: page
slug: display
roxygen:
  rdname: ~
  name: display
  doctype: ~
  title: Tag element display
  description: |-
    Use the `display()` utility to adjust how a tag element is rendered. All
    arguments are responsive allowing you to hide elements on small screens or
    convert elements from inline to block on large screens. Most of the time
    you will use the `render` argument. However if you want to control how an
    element appears (or does not appear) when the page is printed use the `print`
    argument.
  parameters:
  - name: .tag
    description: A tag element.
  - name: render,print
    description: |-
      A [responsive] argument. One of `"inline"`, `"block"`,
      `"inline-block"`, `"flex"`, `"inline-flex"`, or `"none"`, defaults to
      `NULL`.
  sections: ~
  examples: |
    display(div(), render = c(xs = "none", md = "block"))

    display(div(), render = c(xs = "inline", sm = "block"))

    display(div(), print = "none")
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "display <- function(.tag, render = NULL, print = NULL) {\n    possibles
    <- c(\"inline\", \"block\", \"inline-block\", \"flex\", \n        \"inline-flex\",
    \"none\")\n    render <- ensureBreakpoints(render, possibles)\n    print <- ensureBreakpoints(print,
    possibles)\n    classes <- c(createResponsiveClasses(render, \"d\"), createResponsiveClasses(print,
    \n        \"d-print\"))\n    tagAddClass(.tag, classes)\n}"
---
