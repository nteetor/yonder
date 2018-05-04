---
layout: page
slug: padding
roxygen:
  rdname: ~
  name: padding
  doctype: ~
  title: Element margins and padding
  description: |-
    These utilities change the padding or margins of a tag. Each argument value
    may be a single value or a vector of four values. Margins and padding are
    specified as 0, 1, 2, 3, 4, or 5, where 0 removes all space and 5 adds the most
    space.

    Specifying a single value changes the margins or padding along all four sides
    of `tag`. To apply different margins or padding to each side pass a vector of
    four values. In this case, the first value adjusts the top, second the right
    side, third the bottom, and the fourth value adjusts the left side. As a wise
    help page once said, think "**tr**ou**bl**e" to help remember the order.
  parameters:
  - name: tag
    description: A tag element.
  - name: default
    description: |-
      One of 0, 1, 2, 3, 4, 5 specifying the default margins or
        padding to apply. If the margins and padding remain the same across all
        viewports then only `default` needs to be specified.

        For **margins**, specifying `"auto"` leaves the spacing up to the browser.
        For example, you could horizontally center an element for all viewports
        by specifying `default = c(1, "auto", 1, "auto")`.
  - name: sm
    description: |-
      Like `default`, but the margins or padding are applied once the
      viewport is 576 pixels wide, think phone in landscape mode.
  - name: md
    description: |-
      Like `default`, but the margins or padding are applied once the
      viewport is 768 pixels wide, think tablets.
  - name: lg
    description: |-
      Like `default`, but the margins or padding are applied once the
      viewport is 992 pixels wide, think desktop.
  - name: xl
    description: |-
      Like `default`, but the margins or padding are applied once the
      viewport is 1200 pixels wide, think large desktop.
  sections: ~
  examples: |
    if (interactive()) {
      shinyApp(
        ui = container(
          lapply(1:5, function(p) {
            div("Nunc aliquet, augue nec adipiscing interdum.") %>%
              width(25) %>%
              margins(1) %>%
              padding(p) %>%
              border("blue") %>%
              rounded() %>%
              alignment("center")
          })
        ) %>%
          display("flex") %>%
          wrap("wrap"),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "padding <- function(tag, default = NULL, sm = NULL, md = NULL, \n    lg
    = NULL, xl = NULL) {\n    args <- dropNulls(list(default = default, sm = sm, md
    = md, \n        lg = lg, xl = xl))\n    if (length(args) == 0) {\n        stop(\"invalid
    `padding` arguments, at least one argument must not be NULL\", \n            call.
    = FALSE)\n    }\n    classes <- vapply(names2(args), function(nm) {\n        arg
    <- args[[nm]]\n        if (!all(arg %in% 0:5)) {\n            stop(\"invalid `padding`
    argument, `\", nm, \"` value(s) must be 0, 1, 2, 3, 4, or 5\", \n                call.
    = FALSE)\n        }\n        if (length(arg) != 1 && length(arg) != 4) {\n            stop(\"invalid
    `padding` argument, `\", nm, \"` must be a single value or a vector of 4 values\",
    \n                call. = FALSE)\n        }\n        prefix <- \"p\"\n        sides
    <- c(\"t\", \"r\", \"b\", \"l\")\n        breakpoint <- if (nm == \"default\")
    \n            \"-\"\n        else paste0(\"-\", nm, \"-\")\n        if (length(default)
    == 4) {\n            return(paste0(prefix, sides, breakpoint, arg, collapse =
    \" \"))\n        }\n        paste0(prefix, breakpoint, arg)\n    }, character(1))\n
    \   tagAddClass(tag, classes)\n}"
---
