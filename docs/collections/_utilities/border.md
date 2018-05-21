---
layout: page
slug: border
roxygen:
  rdname: ~
  name: border
  doctype: ~
  title: Tag element borders
  description: |-
    Use `border()` to add borders to a tag element or change the color of a tag
    element's border.
  parameters:
  - name: .tag
    description: A tag element.
  - name: color
    description: |-
      A character string specifying the border color, defaults to
      `NULL`, in which case the browser default is used. See below for possible
      border colors.
  - name: sides
    description: |-
      One or more of `"top"`, `"right"`, `"bottom"`, `"left"` or
      `"all"` or `"none"` specifying which sides to add a border to, defaults to
      `"all"`.
  sections: ~
  examples:
  - |-
    h1("") %>%
      border("grey")
  - |
    div("Vivamus id enim.") %>%
      border("orange")

    if (interactive()) {
      colors <- c(
        "red", "purple", "indigo", "blue", "cyan", "teal", "green",
        "yellow", "amber", "orange", "grey", "white"
      )

      shinyApp(
        ui = container(
          center = TRUE,
          lapply(
            colors,
            border,
            tag = div() %>%
              padding(5) %>%
              margin(2)
          )
        ) %>%
          display(flex = TRUE) %>%
          flex(wrap = TRUE),
        server = function(input, output) {

        }
      )
    }
  aliases: ~
  family: utilities
  export: yes
  filename: utilities.R
  source: "border <- function(.tag, color = NULL, sides = \"all\") {\n    if (!re(color,
    paste(color, collapse = \"|\"))) {\n        stop(\"invalid `border()` argument,
    `color` is invalid, see ?border \", \n            \"details for possible colors\",
    call. = FALSE)\n    }\n    if (!all(re(sides, \"top|right|bottom|left|all|none\",
    len0 = FALSE))) {\n        stop(\"invalid `border()` argument, `sides` must be
    one of \", \n            \"\\\"top\\\", \\\"right\\\", \\\"bottom\\\", \\\"left\\\",
    \\\"all\\\", or \\\"none\\\"\", \n            call. = FALSE)\n    }\n    if (!is.null(color))
    {\n        .tag <- colorUtility(.tag, \"border\", color)\n    }\n    if (\"all\"
    %in% sides) {\n        .tag <- tagAddClass(.tag, \"border\")\n    }\n    else
    if (\"none\" %in% sides) {\n        .tag <- tagAddClass(.tag, \"border-0\")\n
    \   }\n    else {\n        .tag <- tagAddClass(.tag, sprintf(\"border-%s\", sides))\n
    \   }\n    .tag\n}"
---
